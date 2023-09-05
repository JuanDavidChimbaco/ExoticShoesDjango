# =========================== rest_framework ============================ 
from rest_framework import viewsets, status, generics
from rest_framework.views import APIView
from rest_framework.viewsets import ViewSet
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated , AllowAny
from rest_framework.pagination import LimitOffsetPagination
from rest_framework.decorators import api_view, permission_classes ,action
from rest_framework.authtoken.models import Token
from rest_framework_jwt.settings import api_settings


# ============================= Django =============================
from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse
from django.core.mail import send_mail
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User, Group

# =============================== Otros ===============================
import os
from datetime import datetime, timedelta
from pyexpat.errors import messages

# ================================ App ================================
from .serializers import (LoginUsuarioSerializer, RegistroUsuarioSerializer, UsuariosSerializer,CategoriasSerializer,ProductosSerializer,CartSerializer, CartItemSerializer,
PagoSerializer,EnvioSerializer,DevolucionesSerializer, PedidoSerializer, DetallePedidoSerializer)
from .models import Usuario,Categoria, Producto,Pedido,DetallePedido,Pago,Envio,Devolucione, Cart, CartItem
from .permissions import AllowOnlyGET  , AllowOnlyPOST
from .decorators import admin_required, client_required


#==================================================================
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
            user = Usuario.objects.create_user(**serializer.validated_data)
            cliente_group = Group.objects.get(name='cliente')  # Asegúrate de que el grupo 'cliente' exista
            user.groups.add(cliente_group)
            token, created = Token.objects.get_or_create(user=user)
            return Response({'message': 'Usuario registrado exitosamente', 'token': token.key}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
 
      
class CategoriasViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowAny]
    queryset = Categoria.objects.all()
    serializer_class = CategoriasSerializer
 
    
class ProductosViewSet(viewsets.ModelViewSet):
    # trae todos los productos que esten activos
    permission_classes = [AllowAny]
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
    permission_classes = [AllowAny]
    queryset = Pedido.objects.all()
    serializer_class = PedidoSerializer


class PedidoDetailViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowAny]
    queryset = DetallePedido.objects.all()
    serializer_class = DetallePedidoSerializer


class PagoViewSet(viewsets.ModelViewSet):
    queryset = Pago.objects.all()
    serializer_class = PagoSerializer


class EnvioViewSet(viewsets.ModelViewSet):
    queryset = Envio.objects.all()
    serializer_class = EnvioSerializer
   
    
class DevolucionesViewSet(viewsets.ModelViewSet):
    queryset = Devolucione.objects.all()
    serializer_class = DevolucionesSerializer
    
    
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
    
#================================================================  
# ========================== Api View ===========================

class LoginClienteView(APIView):
    permission_classes = [AllowOnlyPOST]
    def post(self, request):
        serializer = LoginUsuarioSerializer(data=request.data)
        if serializer.is_valid():
            username = serializer.validated_data['username']
            password = serializer.validated_data['password']
            user = User.objects.filter(username=username).first()
            if user and user.check_password(password):
                login(request, user)
                token, created = Token.objects.get_or_create(user=user)
                return Response({'token': token.key, 'message': 'Inicio de sesión exitoso', 'user': user.id}, status=status.HTTP_200_OK)
            else:
                return Response({'message': 'Credenciales inválidas'}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    
class CustomLoginView(APIView):
    permission_classes = [AllowAny] 
    def post(self, request):
        username = request.data.get("username")
        password = request.data.get("password")
        if username is None or password is None:
            return Response({'error_message': 'Por favor, ingrese ambos campos.'}, status=status.HTTP_400_BAD_REQUEST)
        else:
            user = authenticate(username=username, password=password)
            if user and user.groups.filter(name='admin').exists():
                login(request, user)
                return Response({'message': 'Login exitoso'}, status=status.HTTP_200_OK)
            else:
                return Response({'error_message': 'Usuario no es un administrador.'}, status=status.HTTP_400_BAD_REQUEST)
        
        
class CategoriasList(APIView):
    permission_classes = [AllowAny]
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
        # se encarga de establecer el usuario y la expiración del token
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
        return redirect('inicio')
    
def index(request):
    return render(request, "inicio.html")

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


# ==========================================================================================
#========================= Vistas del Administrador(Logueado) ==========================

# --------------------para testear------------------------------
@admin_required
@api_view(['GET', 'PUT'])
@permission_classes([IsAuthenticated])
def perfil_usuario_api(request):
    usuario = request.user
    if request.method == 'GET':
        # Obtener datos del usuario
        usename = usuario.username
        nombre = usuario.first_name
        apellido = usuario.last_name
        email = usuario.email
        data = {'nombre': nombre, 'apellido': apellido, 'email': email, 'username': usename }
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


def custom_404_view(request, exception):
    nombre_template = 'templates/pageError/404.html'
    return render(request, template_name=nombre_template, status=404)


# --------------------------------testeado------------------------------
@admin_required
def dashboard(request):
    return render(request, "dashboard.html", {})
# admin logueado
@admin_required
def perfil_usuario(request):
    # Puedes acceder a los datos del usuario autenticado a través de request.user
    usuario = request.user
    nombre = usuario.first_name
    apellido = usuario.last_name
    email = usuario.email
    # Realiza cualquier otra operación que necesites con los datos del usuario
    return render(request, 'perfil.html', {'nombre': nombre, 'apellido': apellido, 'email': email})

@admin_required
def categorias(request):
    return render(request, "frmCategorias.html", {})

@admin_required
def productos(request):
    return render(request, "frmProductos.html", {})

@admin_required
def pedidos(request):
    return render(request, "frmPedidos.html", {})

@admin_required
def pagos(request):
    return render(request, "frmPagos.html", {})

@admin_required
def envios(request):
    return render(request, "frmEnvios.html", {})

@admin_required
def devoluciones(request):
    return render(request, "frmDevoluciones.html", {})

@admin_required
def custom_logout(request):
    logout(request)
    return redirect("login")

# ============================================================================
# ================================ Cliente ====================================
    
def inicioCliente(request):
    return render(request, "cliente.html", {})

def registroCliente(request):
    return render(request, "clienteLogueado.html", {})

def cerrar_sesion(request):
    logout(request)
    return redirect('/inicioCliente/')

# ========================================================================
# ================================ Carrito ================================

class CartViewSet(viewsets.ModelViewSet):
    queryset = Cart.objects.all()
    serializer_class = CartSerializer

    @action(detail=True, methods=['post'])
    def agregar_producto(self, request, pk=None):
        cart = self.get_object()
        producto_id = request.data.get('producto_id')
        cantidad = int(request.data.get('cantidad', 1))
        
        try:
            producto = Producto.objects.get(id=producto_id)
        except Producto.DoesNotExist:
            return Response({'error': 'Producto no encontrado'}, status=400)

        cart.agregar_producto(producto, cantidad)
        return Response({'message': 'Producto agregado al carrito'})

    @action(detail=True, methods=['post'])
    def eliminar_producto(self, request, pk=None):
        cart = self.get_object()
        producto_id = request.data.get('producto_id')
        
        try:
            producto = Producto.objects.get(id=producto_id)
        except Producto.DoesNotExist:
            return Response({'error': 'Producto no encontrado'}, status=400)

        cart.eliminar_producto(producto)
        return Response({'message': 'Producto eliminado del carrito'})

    @action(detail=True, methods=['post'])
    def vaciar_carrito(self, request, pk=None):
        cart = self.get_object()
        cart.vaciar_carrito()
        return Response({'message': 'Carrito vaciado'})
    
