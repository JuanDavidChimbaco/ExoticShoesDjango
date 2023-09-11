# =========================== rest_framework ============================
from rest_framework import viewsets, status, generics
from rest_framework.views import APIView
from rest_framework.viewsets import ViewSet
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.pagination import LimitOffsetPagination, PageNumberPagination
from rest_framework.decorators import api_view, permission_classes, action
from rest_framework.authtoken.models import Token
from rest_framework_jwt.settings import api_settings

# ============================= Django =============================
from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse
from django.core.mail import send_mail
from django.db.models import Q, Max
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User, Group

# =============================== Otros ===============================
import os
from datetime import datetime, timedelta

# ================================ App ================================
from .serializers import (
    LoginUsuarioSerializer,
    RegistroUsuarioSerializer,
    # StockSerializer,
    UsuariosSerializer,
    CategoriasSerializer,
    CartSerializer,
    PagoSerializer,
    EnvioSerializer,
    DevolucionesSerializer,
    PedidoSerializer,
    DetallePedidoSerializer,
    ProductoSerializer,
    CategoriaSerializer,
    TallaSerializer,
)
from .models import (
    # Stock,
    Usuario,
    Categoria,
    Producto,
    Pedido,
    DetallePedido,
    Pago,
    Envio,
    Devolucione,
    Cart,
    Talla,
    # TALLAS,
)
from .permissions import AllowOnlyGET, AllowOnlyPOST, AllowOnlyAdminGroup
from .decorators import admin_required, client_required

# ==================================================================================
# ======================================== Api Generica de los productos ===========
class ProductoPagination(PageNumberPagination):
    page_size = 10  # Número de productos por página
    page_size_query_param = 'page_size'
    max_page_size = 50  # Límite máximo de productos por página

class CategoriaViewSet(viewsets.ModelViewSet):
    queryset = Categoria.objects.all()
    serializer_class = CategoriaSerializer


class ProductoPaginationViewSet(viewsets.ModelViewSet):
    queryset = Producto.objects.all()
    serializer_class = ProductoSerializer
    pagination_class = ProductoPagination  # Asigna la paginación personalizada
    
class ProductoViewSet(viewsets.ModelViewSet):
    queryset = Producto.objects.all()
    serializer_class = ProductoSerializer


class TallaViewSet(viewsets.ModelViewSet):
    queryset = Talla.objects.all()
    serializer_class = TallaSerializer


# class ProductoListCreateView(generics.ListCreateAPIView):
#     permission_classes = [AllowOnlyAdminGroup]
#     queryset = Producto.objects.all()
#     serializer_class = ProductoSerializer

#     def perform_create(self, serializer):
#         # Procesa las tallas antes de guardar el producto
#         tallas_data = self.request.data.get("tallas", [])
#         producto = serializer.save()
#         # Asocia las tallas seleccionadas al producto
#         producto.tallas.set(tallas_data)


# class ProductoDetailView(generics.RetrieveUpdateDestroyAPIView):
#     permission_classes = [AllowOnlyGET]
#     queryset = Producto.objects.all()
#     serializer_class = ProductoSerializer


# class StockListCreateView(generics.ListCreateAPIView):
#     queryset = Stock.objects.all()
#     serializer_class = StockSerializer


# class StockDetailView(generics.RetrieveUpdateDestroyAPIView):
#     queryset = Stock.objects.all()
#     serializer_class = StockSerializer


# ==================================================================
# ========================== Api ViewSet ==========================
# ------------------------testeado---------------------
class UsuariosViewSet(viewsets.ModelViewSet):
    queryset = Usuario.objects.all()
    serializer_class = UsuariosSerializer


class RegistroClienteViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowAny]
    queryset = Usuario.objects.all()
    serializer_class = RegistroUsuarioSerializer

    @action(detail=False, methods=["post"])
    def create(self, request):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            # Verificar si el correo electrónico ya está en uso
            email = serializer.validated_data["email"]
            if Usuario.objects.filter(Q(email=email) | Q(username=email)).exists():
                return Response(
                    {"message": "Este correo electrónico ya está en uso."},
                    status=status.HTTP_400_BAD_REQUEST,
                )
            # Crear el usuario
            user = Usuario.objects.create_user(**serializer.validated_data)
            cliente_group = Group.objects.get_or_create(name="cliente")[
                0
            ]  # Asegúrate de que el grupo 'cliente' exista
            user.groups.add(cliente_group)
            return Response(
                {"message": "Usuario registrado exitosamente"},
                status=status.HTTP_201_CREATED,
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class CategoriasViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowOnlyAdminGroup]
    queryset = Categoria.objects.all()
    serializer_class = CategoriasSerializer


class ProductosViewSet(viewsets.ModelViewSet):
    # trae todos los productos que esten activos
    permission_classes = [AllowAny]
    queryset = Producto.objects.filter(estado=True)
    serializer_class = ProductoSerializer

    def perform_destroy(self, instance):
        instance.estado = False
        instance.save()

    def perform_create(self, serializer):
        categoria_id = self.request.data.get(
            "categoria"
        )  # Obtén el ID de la categoría del request
        categoria = Categoria.objects.get(
            id=categoria_id
        )  # Obtén la instancia de categoría
        serializer.save(categoria=categoria)  # Asigna la categoría al producto y guarda


class ProductosFiltradosPorCategoriaViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowOnlyGET]
    serializer_class = ProductoSerializer

    def get_queryset(self):
        queryset = Producto.objects.filter(estado=True)
        # Obtener el parámetro de ID de categoría de la URL
        categoria_id = self.request.query_params.get("categoria_id", None)
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

    def create(self, request, *args, **kwargs):
        # Obtener el último código de pedido
        last_codigo = Pedido.objects.aggregate(Max("codigoPedido"))["codigoPedido__max"]
        if last_codigo:
            codigo_numero = int(last_codigo[3:]) + 1
            nuevo_codigo = f"COD{codigo_numero:03d}"
        else:
            nuevo_codigo = "COD001"
        request.data["codigoPedido"] = nuevo_codigo  # Agregar el código al request data
        return super().create(request, *args, **kwargs)


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
        serializer = ProductoSerializer(paginated_productos, many=True)
        return paginator.get_paginated_response(serializer.data)


# ================================================================
# ========================== Api View ===========================


class LoginClienteView(APIView):
    permission_classes = [AllowOnlyPOST]

    def post(self, request):
        serializer = LoginUsuarioSerializer(data=request.data)
        if serializer.is_valid():
            username = serializer.validated_data["username"]
            password = serializer.validated_data["password"]
            user = Usuario.objects.filter(username=username).first()
            if user and user.check_password(password):
                login(request, user)
                token, created = Token.objects.get_or_create(user=user)
                user_data = UsuariosSerializer(user).data
                response = Response(
                    {
                        "token": token.key,
                        "message": "Inicio de sesión exitoso",
                        "user": user_data,
                    },
                    status=status.HTTP_200_OK,
                )
                response.set_cookie("token", token.key)
                return response
            else:
                return Response(
                    {"message": "Credenciales inválidas"},
                    status=status.HTTP_401_UNAUTHORIZED,
                )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# ------------------- login Api Administrador   ----------------------------
@api_view(["POST"])
@permission_classes([AllowOnlyPOST])
def custom_login(request):
    username = request.data.get("username")
    password = request.data.get("password")
    rememberMe = request.data.get("rememberme")
    user = authenticate(
        request, username=username, password=password
    )  # se encarga de autenticar los datos que llegan
    if user is None:
        return Response(
            {"message": "Credenciales incorrectas"}, status=status.HTTP_401_UNAUTHORIZED
        )
    else:
        login(request, user)  # crea una sessionid con ese usuario
        if rememberMe:
            request.session.set_expiry(2592000)  # 30 días en segundos
        else:
            request.session.set_expiry(0)  # Duración predeterminada
        return Response(
            {"message": "Inicio de sesión exitoso"}, status=status.HTTP_200_OK
        )


@admin_required
@api_view(["GET", "PUT"])
@permission_classes([IsAuthenticated])
def perfil_usuario_api(request):
    usuario = request.user
    if request.method == "GET":
        # Obtener datos del usuario
        usename = usuario.username
        nombre = usuario.first_name
        apellido = usuario.last_name
        email = usuario.email
        data = {
            "nombre": nombre,
            "apellido": apellido,
            "email": email,
            "username": usename,
        }
        return Response(data)
    elif request.method == "PUT":
        # Actualizar datos del usuario
        nuevo_nombre = request.data.get("nombre")
        nuevo_apellido = request.data.get("apellido")
        nuevo_email = request.data.get("email")
        if nuevo_nombre:
            usuario.first_name = nuevo_nombre
        if nuevo_apellido:
            usuario.last_name = nuevo_apellido
        if nuevo_email:
            usuario.email = nuevo_email
        usuario.save()
    return Response(status=status.HTTP_204_NO_CONTENT)


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
            return render(
                request, "registration/restablecer_password.html", {"mensaje": mensaje}
            )
        # Generar el token de restablecimiento
        jwt_payload_handler = api_settings.JWT_PAYLOAD_HANDLER
        jwt_encode_handler = api_settings.JWT_ENCODE_HANDLER
        # se encarga de establecer el usuario y la expiración del token
        payload = jwt_payload_handler(user)
        payload["exp"] = datetime.utcnow() + timedelta(
            hours=1
        )  # Establecer la expiración a 1 hora
        token = jwt_encode_handler(payload)
        # Construir el enlace para la vista de restablecimiento de contraseña
        reset_link = request.build_absolute_uri(
            reverse("nuevaContra") + f"?token={token}"
        )
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
            return Response(
                {"detail": "El token no es válido."}, status=status.HTTP_400_BAD_REQUEST
            )
        # Actualizar la contraseña del usuario
        user.set_password(new_password)
        user.save()
        # return Response({"detail": "Contraseña actualizada exitosamente."})
        return render(request, "registration/reset_password_success.html")


# =====================================================================================
# ====================== Vistas del Administrador (Sin-logearse)======================


def redirect_to_login(request):
    return redirect("dashboard")


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
    token = request.GET.get("token", "")
    return render(
        request, "registration/restablecer_password_form.html", {"token": token}
    )


# ==========================================================================================
# ========================= Vistas del Administrador(Logueado) ==========================

# --------------------para testear------------------------------


def custom_404_view(request, exception):
    nombre_template = "templates/pageError/404.html"
    return render(request, template_name=nombre_template, status=404)


# --------------------------------testeado------------------------------
# admin logueado
@admin_required
def dashboard(request):
    return render(request, "dashboard.html", {})


@admin_required
def perfil_usuario(request):
    return render(request, "perfil.html", {})


@admin_required
def categorias(request):
    return render(request, "frmCategorias.html", {})


@admin_required
def productos(request):
    return render(request, "frmProductos.html", {})


@admin_required
def tallas(request):
    return render(request, "frmTallas.html", {})


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


def loginCliente(request):
    return render(request, "login_cliente.html", {})


def registroCliente(request):
    return render(request, "registro_cliente.html", {})


@client_required
def inicioCliente(request):
    return render(request, "inicio_cliente.html", {})


def cerrar_sesion(request):
    logout(request)
    return redirect("login_cliente/")


# ========================================================================
# ================================ Carrito ================================


class CartViewSet(viewsets.ModelViewSet):
    queryset = Cart.objects.all()
    serializer_class = CartSerializer

    @action(detail=True, methods=["post"])
    def agregar_producto(self, request, pk=None):
        cart = self.get_object()
        producto_id = request.data.get("producto_id")
        cantidad = int(request.data.get("cantidad", 1))

        try:
            producto = Producto.objects.get(id=producto_id)
        except Producto.DoesNotExist:
            return Response({"error": "Producto no encontrado"}, status=400)

        cart.agregar_producto(producto, cantidad)
        return Response({"message": "Producto agregado al carrito"})

    @action(detail=True, methods=["post"])
    def eliminar_producto(self, request, pk=None):
        cart = self.get_object()
        producto_id = request.data.get("producto_id")

        try:
            producto = Producto.objects.get(id=producto_id)
        except Producto.DoesNotExist:
            return Response({"error": "Producto no encontrado"}, status=400)

        cart.eliminar_producto(producto)
        return Response({"message": "Producto eliminado del carrito"})

    @action(detail=True, methods=["post"])
    def vaciar_carrito(self, request, pk=None):
        cart = self.get_object()
        cart.vaciar_carrito()
        return Response({"message": "Carrito vaciado"})
