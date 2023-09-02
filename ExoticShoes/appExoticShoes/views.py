from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.viewsets import ViewSet
from rest_framework.permissions import IsAuthenticated
from rest_framework.pagination import LimitOffsetPagination
from rest_framework.permissions import AllowAny
from rest_framework import viewsets, status
from rest_framework.generics import RetrieveUpdateAPIView
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from rest_framework.decorators import action
from .permissions import AllowOnlyGET
from .permissions import AllowOnlyPOST
from .models import Usuario,Categoria, Producto,Pedido,DetallePedido,Pago,Envio,Devolucione, CartItem , Cart
from .serializers import (LoginUsuarioSerializer, RegistroUsuarioSerializer, UsuariosSerializer,CategoriasSerializer,ProductosSerializer,CartSerializer,CartItemSerializer,
PedidosSerializer,DetallePedidoSerializer,PagoSerializer,EnvioSerializer,DevolucionesSerializer)
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
from django.shortcuts import render, redirect, get_object_or_404
from django.conf import settings
from django.utils import timezone
from django.urls import reverse
from pyexpat.errors import messages
import os


from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.models import User
from django.core.mail import send_mail
from rest_framework_jwt.settings import api_settings
from datetime import datetime, timedelta

#================================================================ 
# ========================== Api ViewSet ==========================
# ------------------------testeado---------------------
class UsuariosViewSet(viewsets.ModelViewSet):
    queryset = Usuario.objects.all()
    serializer_class = UsuariosSerializer


class RegistroClienteViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowOnlyPOST]
    queryset = Usuario.objects.all()
    serializer_class = RegistroUsuarioSerializer

    @action(detail=False, methods=['post'])
    def registrar_usuario(self, request):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            usuario = serializer.save()
            token, created = Token.objects.get_or_create(user=usuario)
            return Response({'message': 'Usuario registrado exitosamente', 'token': token.key}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
 
      
class CategoriasViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowOnlyGET]
    queryset = Categoria.objects.all()
    serializer_class = CategoriasSerializer
 
    
class ProductosViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowOnlyGET]
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

        
class ProductosFiltradosPorCategoriaViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowOnlyGET]
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
    
        
class PedidosViewSet(viewsets.ModelViewSet):
    queryset = Pedido.objects.all()
    serializer_class = PedidosSerializer
    
    def perform_create(self, serializer):
        # Obtén el ID del usuario existente que se asigna al pedido
        usuario_id = self.request.data.get('usuario_id', None)

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
    
#================================================================  
# ========================== Api View ===========================
class LoginUsuarioView(APIView):
    permission_classes = [AllowOnlyPOST]
    def post(self, request):
        serializer = LoginUsuarioSerializer(data=request.data)
        if serializer.is_valid():
            user = authenticate(username=serializer.validated_data['username'], password=serializer.validated_data['password'])
            if user is not None:
                login(request, user)
                token, created = Token.objects.get_or_create(user=user)
                return Response({'token': token.key, 'message': 'Inicio de sesión exitoso'}, status=status.HTTP_200_OK)
            else:
                return Response({'message': 'Credenciales inválidas'}, status=status.HTTP_401_UNAUTHORIZED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class CustomLimitOffsetPagination(LimitOffsetPagination):
    default_limit = 4

class ProductosListView(ViewSet):
    permission_classes = [AllowOnlyGET]
    pagination_class = CustomLimitOffsetPagination
    def list(self, request):
        productos = Producto.objects.filter(estado=True)
        paginator = LimitOffsetPagination()
        paginated_productos = paginator.paginate_queryset(productos, request)
        serializer = ProductosSerializer(paginated_productos, many=True)
        return paginator.get_paginated_response(serializer.data)

     
class CategoriasList(APIView):
    def get(self, request):
        categorias = Categoria.objects.all()
        serializer = CategoriasSerializer(categorias, many=True)
        return Response(serializer.data)


class ProductosList(APIView):
    permission_classes = [AllowAny]
    def get(self, request):
        productos = Producto.objects.all()
        serializer = ProductosSerializer(productos, many=True)
        return Response(serializer.data)

# --------------------------/ reset password /------------------------------
# -------------------------- para testear ----------------------------
# Se encarga de enviar el correo electrónico con el enlace de restablecimiento
class PasswordResetRequestView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        email = request.data.get("email")
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            mensaje = "Correo no encontrado"
            return render(request, "registration/restablecer_password.html", {"mensaje": mensaje})
        
        # Generar el token de restablecimiento
        jwt_payload_handler = api_settings.JWT_PAYLOAD_HANDLER
        jwt_encode_handler = api_settings.JWT_ENCODE_HANDLER
        
        payload = jwt_payload_handler(user)
        payload["exp"] = datetime.utcnow() + timedelta(hours=1)  # Establecer la expiración a 1 hora
        
        token = jwt_encode_handler(payload)
        
         # Construir el enlace para la vista de restablecimiento de contraseña
        reset_link = request.build_absolute_uri(reverse('nuevaContra') + f"?token={token}")
        
        # Enviar el correo electrónico con el enlace de restablecimiento
        subject = "Restablecimiento de contraseña"
        message = f"Haz clic en el siguiente enlace para restablecer tu contraseña:\n\n{reset_link}"
        
        send_mail(subject, message, "ExoticShoes@Shop.com", [email])
        mensaje = "Se ha enviado un enlace de restablecimiento a su correo electrónico."
        return render(request, "registration/mensaje.html", {"mensaje": mensaje})

# -----------------------------para testear-----------------------
# obtiene el token y la nueva contraseña y actualiza la contraseña del usuario
class PasswordResetView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        token = request.data.get("token")
        new_password = request.data.get("new_password")
        
        try:
            payload = api_settings.JWT_DECODE_HANDLER(token)
            user = User.objects.get(id=payload["user_id"])
        except User.DoesNotExist:
            return Response({"detail": "El token no es válido."}, status=status.HTTP_400_BAD_REQUEST)
        
        # Actualizar la contraseña del usuario
        user.set_password(new_password)
        user.save()
        
        # return Response({"detail": "Contraseña actualizada exitosamente."})
        return render(request, "registration/reset_password_success.html")

    
#=====================================================================================
# ====================== Vistas del Administrador (Sin-logearse)======================


def redirect_to_login(request):
    return redirect("login")

def custom_login(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        user = authenticate(username=username, password=password)
        if user:
            login(request, user)
            request.session["login_success_message"] = "¡Login exitoso!"
            return render(request, "inicio_sesion.html", {"login_success_message": request.session["login_success_message"]})
        else:
            error_message = "Usuario o contraseña incorrectos. Por favor, inténtalo de nuevo."
            return render(request, "inicio_sesion.html", {"error_message": error_message})
    
    return render(request, "inicio_sesion.html")

# ------------------------para testear------------------------------
# vista para validar correo y enviar el enlace de restablecimiento
def restPasswordRequest(request):
    return render(request, "registration/restablecer_password.html")

# vista para mostrar mensaje de que se envio el correo
def mensajeCorreo(request):
    return render(request, "registration/mensaje_correo.html")

# vista para digitar la nueva contraseña
def restPassword(request):
    token = request.GET.get('token', '')
    return render(request, "registration/restablecer_password_form.html", {"token": token})

#========================= Vistas del Administrador(Logueado) ==========================

# --------------------para testear------------------------------
# admin logueado
@login_required
def perfil_usuario(request):
    # Puedes acceder a los datos del usuario autenticado a través de request.user
    usuario = request.user
    nombre = usuario.first_name
    apellido = usuario.last_name
    email = usuario.email
    # Realiza cualquier otra operación que necesites con los datos del usuario
    return render(request, 'perfil.html', {'nombre': nombre, 'apellido': apellido, 'email': email})

# cliente logueado 
from rest_framework.decorators import api_view, permission_classes
@api_view(['GET', 'PUT'])
@permission_classes([IsAuthenticated])
def perfil_usuario_api(request):
    usuario = request.user

    if request.method == 'GET':
        # Obtener datos del usuario

        nombre = usuario.first_name
        apellido = usuario.last_name
        email = usuario.email

        data = {'nombre': nombre, 'apellido': apellido, 'email': email}
        return Response(data)
    
    elif request.method == 'PUT':
        # Actualizar datos del usuario

        nuevo_nombre = request.data.get('nombre')
        nuevo_apellido = request.data.get('apellido')
        nuevo_email = request.data.get('email')

        if nuevo_nombre:
            usuario.first_name = nuevo_nombre
        if nuevo_apellido:
            usuario.last_name = nuevo_apellido
        if nuevo_email:
            usuario.email = nuevo_email

        usuario.save()

        return Response(status=status.HTTP_204_NO_CONTENT)

# ============================decoradores para las vistas ==================================

def admin_required(view_func):
    def _wrapped_view(request, *args, **kwargs):
        if request.user.is_authenticated:
            if request.user.is_staff:
                return view_func(request, *args, **kwargs)
            else:
                mensaje = "No tienes permisos para acceder a esta página."
                return render(request, "templates/pageError/ErrorPage.html", {'mensaje':mensaje})
        return redirect("login")
    return _wrapped_view

def client_required(view_func):
    def _wrapped_view(request, *args, **kwargs):
        if request.user.is_authenticated:
            if not request.user.is_staff:
                return view_func(request, *args, **kwargs)
        else:
            pass
    return _wrapped_view

def custom_404_view(request, exception):
    nombre_template = 'templates/pageError/404.html'
    return render(request, template_name=nombre_template, status=404)


# --------------------------------testeado------------------------------
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