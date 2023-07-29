from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from .models import Usuarios,Categorias, Productos,ItemCarrito,Pedidos,DetallePedido,Pago,Envio,Devoluciones
from .serializers import (UsuariosSerializer,CategoriasSerializer,ProductosSerializer,ItemCarritoSerializer,
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


class UsuariosViewSet(viewsets.ModelViewSet):
    queryset = Usuarios.objects.all()
    serializer_class = UsuariosSerializer


class CategoriasViewSet(viewsets.ModelViewSet):
    queryset = Categorias.objects.all()
    serializer_class = CategoriasSerializer


class ProductosViewSet(viewsets.ModelViewSet):
    # trae todos los productos que esten activos
    queryset = Productos.objects.filter(estado=True)
    serializer_class = ProductosSerializer

    def perform_destroy(self, instance):
        instance.estado = False
        instance.save()


class ItemCarritoViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    queryset = ItemCarrito.objects.all()
    serializer_class = ItemCarritoSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save(usuario=self.request.user)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return Response(status=status.HTTP_204_NO_CONTENT)


class PedidosViewSet(viewsets.ModelViewSet):
    queryset = Pedidos.objects.all()
    serializer_class = PedidosSerializer


class DetallePedidoViewSet(viewsets.ModelViewSet):
    serializer_class = DetallePedidoSerializer
    queryset = DetallePedido.objects.all()


class PagoViewSet(viewsets.ModelViewSet):
    queryset = Pago.objects.all()
    serializer_class = PagoSerializer


class EnvioViewSet(viewsets.ModelViewSet):
    queryset = Envio.objects.all()
    serializer_class = EnvioSerializer


class DevolucionesViewSet(viewsets.ModelViewSet):
    queryset = Devoluciones.objects.all()
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
            pedido = Pedidos.objects.get(pk=pedido_id)
        except Pedidos.DoesNotExist:
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


# ------------------- Vistas -------------------


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
            error_message = (
                "Usuario o contraseña incorrectos. Por favor, inténtalo de nuevo."
            )
            return render(
                request, "inicio_sesion.html", {"error_message": error_message}
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
def envios(request):
    return render(request, "frmEnvios.html", {})


@login_required(login_url="/")
def custom_logout(request):
    logout(request)
    return redirect("login")


@login_required(login_url="/")
def convertir_a_pedido(request):
    if request.user.is_authenticated:
        usuario = request.user
        carrito = ItemCarrito.objects.filter(usuario=usuario)

        # Crear el objeto Pedido
        pedido = Pedidos.objects.create(fechaPedido=timezone.now(), usuario=usuario)

        # Crear los DetallePedido asociados al Pedido
        for item in carrito:
            DetallePedido.objects.create(
                pedido=pedido,
                producto=item.producto,
                cantidad=item.cantidad,
                subtotal=item.producto.precio * item.cantidad,
            )

        # Vaciar el carrito (eliminar todos los elementos del carrito)
        carrito.delete()

        return redirect(
            "vista_del_carrito"
        )  # O redireccionar a una vista de confirmación de pedido
    else:
        # Manejar el caso de usuario no autenticado si es necesario.
        pass


@login_required(login_url="/")
def agregar_al_carrito(request, producto_id):
    if request.user.is_authenticated:
        producto = Productos.objects.get(pk=producto_id)
        usuario = Usuarios.objects.get(Usuarios=request.user)
        item_carrito, created = ItemCarrito.objects.get_or_create(
            usuario=usuario, producto=producto
        )
        if not created:
            item_carrito.cantidad += 1
            item_carrito.save()

        return redirect("vista_del_carrito")
    else:
        # Aquí puedes manejar el caso de un usuario no autenticado, por ejemplo, redirigiéndolo a la página de inicio de sesión.
        pass


@login_required(login_url="/")
def eliminar_del_carrito(request, item_id):
    if request.user.is_authenticated:
        usuario = request.user

        try:
            item_carrito = ItemCarrito.objects.get(pk=item_id, usuario=usuario)
            item_carrito.delete()
        except ItemCarrito.DoesNotExist:
            pass

        return redirect("vista_del_carrito")
    else:
        # Manejar el caso de usuario no autenticado si es necesario.
        pass


@login_required(login_url="/")
def vista_del_carrito(request):
    if request.user.is_authenticated:
        usuario = request.user
        items_carrito = ItemCarrito.objects.filter(usuario=usuario)
        total_carrito = sum(
            item.producto.precio * item.cantidad for item in items_carrito
        )

        context = {
            "items_carrito": items_carrito,
            "total_carrito": total_carrito,
        }

        return render(request, "carrito.html", context)
    else:
        # Manejar el caso de usuario no autenticado si es necesario.
        pass
