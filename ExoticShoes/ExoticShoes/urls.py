from django.contrib import admin
from django.conf import settings
from django.conf.urls.static import static
from django.urls import include, path

from rest_framework.routers import DefaultRouter
from appExoticShoes.views import (
    PasswordResetRequestView,
    PasswordResetView,
    CategoriaViewSet,
    ProductoViewSet,
    TallaViewSet,
)
from appExoticShoes import views


# router para las rutas de la Api
router = DefaultRouter()
router.register(r"usuarios", views.UsuariosViewSet, basename="usuarios")
router.register(r"carrito", views.CartViewSet, basename="carrito")
router.register(r"pedidos", views.PedidosViewSet, basename="pedidos")
router.register(r"detallePedidos", views.PedidoDetailViewSet, basename="detallePedido")
router.register(r"pago", views.PagoViewSet, basename="pago")
router.register(r"envio", views.EnvioViewSet, basename="envio")
router.register(r"devoluciones", views.DevolucionesViewSet, basename="devoluciones")
router.register(r"categorias", CategoriaViewSet)
router.register(r"categorias2", views.CategoriaViewSet2)
router.register(r"productos", ProductoViewSet)
router.register(r"productos2", views.ProductoViewSetCliente)
router.register(r"productosPagination", views.ProductoPaginationViewSet)
router.register(r"tallas", TallaViewSet)

# lista de productos para la vista del cliente
registro_cliente_view = views.RegistroClienteViewSet.as_view({"post": "create"})

urlpatterns = [
    # Rutas para la vista del Administrador
    path("admin/", admin.site.urls),
    path("", views.redirect_to_login, name="redirect_to_login"),
    path("inicio/", views.index, name="login"),
    path("dashboard/", views.dashboard, name="dashboard"),
    path("frmCategorias/", views.categorias, name="categorias"),
    path("frmProductos/", views.productos, name="productos"),
    path("frmTallas/", views.tallas, name="tallas"),
    path("frmPedidos/", views.pedidos, name="pedidos"),
    path("frmEnvios/", views.envios, name="envios"),
    path("frmPagos/", views.pagos, name="pagos"),
    path("frmDevoluciones/", views.devoluciones, name="devoluciones"),
    path("api/login/", views.custom_login, name="api-login"),
    path("logout/", views.custom_logout, name="logout"),
    
    # rutas de la Api
    path("api/v1.0/", include(router.urls)),
    path("api/v1.0/registro_cliente/", registro_cliente_view, name="registro_cliente"),
    path("api/v1.0/sesion_cliente/", views.LoginClienteView.as_view(),name="sesion_cliente",),
    
    # rutas para restablecer contraseña (Admin)
    path("validarCorreo/", views.restPasswordRequest, name="validarCorreo"),
    path("nuevaContra/", views.restPassword, name="nuevaContra"),
    path("mensajeCorreo/", views.mensajeCorreo, name="mensajeCorreo"),
    path("resetLink/", PasswordResetRequestView.as_view(), name="resetLink"),
    path("resetPassword/", PasswordResetView.as_view(), name="resetPassword"),
    
    # login de usuarios (Cliente)
    path("registro_cliente/", views.registroCliente, name="registro_cliente"),
    path("login_cliente/", views.loginCliente, name="login_cliente"),
    path("inicio_cliente/", views.inicioCliente, name="inicio_cliente"),
    path("custom_logout/", views.cerrar_sesion, name="custom_logout"),
    path("inicio_tienda/", views.inicio_Tienda, name="inicio_tienda"),
    
    # perfil de usuario(Admin)
    path("perfil/", views.perfil_usuario, name="perfil"),
    path("api/v1.0/perfilApi/", views.PerfilUsuarioAPIView.as_view(), name="perfilApi"),
    
    # filtros 
    path('api/v1.0/pedidos/<int:pedido_id>/detalles/', views.DetallePedidoPorPedidoView.as_view(), name='detallepedido-por-pedido'),
]
handler404 = 'appExoticShoes.views.custom_404'

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
