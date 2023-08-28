from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.viewsets import ViewSet
from rest_framework.permissions import IsAuthenticated
from rest_framework.pagination import LimitOffsetPagination
from .models import Usuario,Categoria, Producto,Pedido,DetallePedido,Pago,Envio,Devolucione, CartItem , Cart
from .serializers import (UsuariosSerializer,CategoriasSerializer,ProductosSerializer,CartSerializer,CartItemSerializer,
PedidosSerializer,DetallePedidoSerializer,PagoSerializer,EnvioSerializer,DevolucionesSerializer)
from rest_framework import viewsets, status
from rest_framework.response import Response
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
from django.shortcuts import render, redirect, get_object_or_404
from django.conf import settings
from django.utils import timezone
from pyexpat.errors import messages
import os


# ========================== Api ==========================
class UsuariosViewSet(viewsets.ModelViewSet):
    queryset = Usuario.objects.all()
    serializer_class = UsuariosSerializer


class CategoriasViewSet(viewsets.ModelViewSet):
    queryset = Categoria.objects.all()
    serializer_class = CategoriasSerializer


class ProductosViewSet(viewsets.ModelViewSet):
    # trae todos los productos que esten activos
    queryset = Producto.objects.filter(estado=True)
    serializer_class = ProductosSerializer

    def perform_destroy(self, instance):
        instance.estado = False
        instance.save()
    
    def perform_create(self, serializer):
        categoria_id = self.request.data.get('categoria')  # Obtén el ID de la categoría del request
        categoria = Categoria.objects.get(id=categoria_id)  # Obtén la instancia de categoría
        serializer.save(categoria=categoria)  # Asigna la categoría al producto y guarda


class CustomLimitOffsetPagination(LimitOffsetPagination):
    default_limit = 4


class ProductosListView(ViewSet):
    pagination_class = CustomLimitOffsetPagination
    def list(self, request):
        productos = Producto.objects.filter(estado=True)
        paginator = LimitOffsetPagination()
        paginated_productos = paginator.paginate_queryset(productos, request)
        serializer = ProductosSerializer(paginated_productos, many=True)
        return paginator.get_paginated_response(serializer.data)


class ProductosFiltradosPorCategoriaViewSet(viewsets.ModelViewSet):
    serializer_class = ProductosSerializer
    def get_queryset(self):
        queryset = Producto.objects.filter(estado=True)
        # Obtener el parámetro de ID de categoría de la URL
        categoria_id = self.request.query_params.get('categoria_id', None)
        if categoria_id:
            queryset = queryset.filter(categoria_id=categoria_id)
        return queryset

    def perform_destroy(self, instance):
        instance.estado = False
        instance.save()
        
class CategoriasList(APIView):
    def get(self, request):
        categorias = Categoria.objects.all()
        serializer = CategoriasSerializer(categorias, many=True)
        return Response(serializer.data)

class ProductosList(APIView):
    def get(self, request):
        productos = Producto.objects.all()
        serializer = ProductosSerializer(productos, many=True)
        return Response(serializer.data)


class PedidosViewSet(viewsets.ModelViewSet):
    queryset = Pedido.objects.all()
    serializer_class = PedidosSerializer
    
    def perform_create(self, serializer):
        # Obtén el ID del usuario existente que deseas asignar al pedido
        usuario_id = self.request.data.get('usuario_id', None)  # Asegúrate de ajustar el nombre del campo

        if usuario_id is not None:
            usuario = Usuario.objects.get(pk=usuario_id)
            serializer.save(usuario=usuario)
        else:
            serializer.save()
    
    
class DetallePedidoViewSet(viewsets.ModelViewSet):
    serializer_class = DetallePedidoSerializer
    queryset = DetallePedido.objects.all()

    def create(self, request, *args, **kwargs):
        detalles = request.data.get('detalles', [])  # Obtén la lista de detalles

        # Serializa cada detalle y calcula el subtotal
        detalles_serialized = []
        total_pedido = 0
        for detalle_data in detalles:
            serializer = DetallePedidoSerializer(data=detalle_data)
            if serializer.is_valid():
                cantidad = detalle_data.get('cantidad', 0)
                precio_producto = detalle_data.get('producto', {}).get('precio', 0)
                subtotal = precio_producto * cantidad
                total_pedido += subtotal
                detalles_serialized.append({'serializer': serializer, 'subtotal': subtotal})
            else:
                return Response(serializer.errors, status=400)

        # Crea los detalles y actualiza el total del pedido
        pedido_id = request.data.get('pedido_id', None)
        if pedido_id is not None:
            pedido = Pedido.objects.get(pk=pedido_id)
            for detalle_info in detalles_serialized:
                serializer = detalle_info['serializer']
                detalle = serializer.save(subtotal=detalle_info['subtotal'])
                pedido.total += detalle.subtotal
            pedido.save()

        return Response({'message': 'Detalles de pedido creados exitosamente', 'total_pedido': total_pedido})

class PagoViewSet(viewsets.ModelViewSet):
    queryset = Pago.objects.all()
    serializer_class = PagoSerializer

class EnvioViewSet(viewsets.ModelViewSet):
    queryset = Envio.objects.all()
    serializer_class = EnvioSerializer
    
class DevolucionesViewSet(viewsets.ModelViewSet):
    queryset = Devolucione.objects.all()
    serializer_class = DevolucionesSerializer

class ProcesarPagoView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, pedido_id):
        # Obtener los detalles del pago desde los datos JSON
        metodo = request.data.get("metodo_pago")
        monto = float(request.data.get("monto_pago"))
        fecha = timezone.now()

        # Obtener el pedido correspondiente
        try:
            pedido = Pedido.objects.get(pk=pedido_id)
        except Pedido.DoesNotExist:
            return Response(
                {"error": "Pedido no encontrado"}, status=status.HTTP_404_NOT_FOUND
            )

        # Crear el objeto Pago
        pago = Pago.objects.create(
            metodo=metodo, monto=monto, fecha=fecha, pedidos=pedido
        )

        # Actualizar el estado del pedido (opcional)
        # Aquí puedes cambiar el estado del pedido a "pagado" o realizar otras acciones relacionadas con el pago.

        serializer = PagoSerializer(pago)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    

# ====================== Vistas del Administrador ======================


def redirect_to_login(request):
    return redirect("login")

def custom_login(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]
        user = authenticate(username=username, password=password)
        if user is not None:
            login(request, user)
            request.session["login_success_message"] = "¡Login exitoso!"
            return render(
                request,
                "inicio_sesion.html",
                {"login_success_message": request.session["login_success_message"]},
            )
        else:
            error_message = ("Usuario o contraseña incorrectos. Por favor, inténtalo de nuevo.")
            return render(
                request, 
                "inicio_sesion.html", 
                {"error_message": error_message}
            )
    return render(request, "inicio_sesion.html")

@login_required(login_url="login")
def inicio(request):
    return render(request, "dashboard.html", {})

@login_required(login_url="/")
def categorias(request):
    return render(request, "frmCategorias.html", {})

@login_required(login_url="/")
def productos(request):
    return render(request, "frmProductos.html", {})

@login_required(login_url="/")
def pedidos(request):
    return render(request, "frmPedidos.html", {})

@login_required(login_url="/")
def pagos(request):
    return render(request, "frmPagos.html", {})

@login_required(login_url="/")
def envios(request):
    return render(request, "frmEnvios.html", {})

@login_required(login_url="/")
def devoluciones(request):
    return render(request, "frmDevoluciones.html", {})

@login_required(login_url="/")
def custom_logout(request):
    logout(request)
    return redirect("login")


# ================================ Carrito ================================

class CartDetail(APIView):
    def get_cart(self, user):
        cart, created = Cart.objects.get_or_create(user=user)
        return cart

    def get(self, request):
        cart = self.get_cart(request.user)
        serializer = CartSerializer(cart)
        return Response(serializer.data)

    def post(self, request):
        product_id = request.data.get('product_id')
        quantity = request.data.get('quantity', 1)

        if product_id is None:
            return Response({'error': 'Product ID is required.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            product = Producto.objects.get(id=product_id)
        except Producto.DoesNotExist:
            return Response({'error': 'Product not found.'}, status=status.HTTP_404_NOT_FOUND)

        cart = self.get_cart(request.user)
        cart_item, created = CartItem.objects.get_or_create(cart=cart, product=product)
        cart_item.quantity += int(quantity)
        cart_item.save()

        serializer = CartSerializer(cart)
        return Response(serializer.data)

    def delete(self, request, product_id):
        try:
            product = Producto.objects.get(id=product_id)
        except Producto.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        cart = self.get_cart(request.user)
        cart.items.filter(product=product).delete()

        serializer = CartSerializer(cart)
        return Response(serializer.data)