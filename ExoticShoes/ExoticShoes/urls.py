from django.contrib import admin
from django.conf import settings
from django.conf.urls.static import static
from django.urls import include, path
from rest_framework import routers
from appExoticShoes.views import LoginUsuarioView, RegistroUsuarioView
from appExoticShoes.views import ProductosListView , ProductosFiltradosPorCategoriaViewSet, CartDetail, CategoriasList, ProductosList , PasswordResetRequestView, PasswordResetView
from appExoticShoes import views


# router para las rutas de la Api
router = routers.DefaultRouter()
router.register(r'usuarios', views.UsuariosViewSet)
router.register(r'categorias', views.CategoriasViewSet)
router.register(r'productos', views.ProductosViewSet)
router.register(r'productos-filtrados', ProductosFiltradosPorCategoriaViewSet, basename='productos-filtrados')
router.register(r'pedidos', views.PedidosViewSet, basename='pedidos')
router.register(r'detallePedidos', views.DetallePedidoViewSet,basename='detallepedido')
router.register(r'pago', views.PagoViewSet)
router.register(r'envio', views.EnvioViewSet)
router.register(r'devoluciones', views.DevolucionesViewSet)

# lista de productos para la vista del cliente
producto_list_view = ProductosListView.as_view({'get': 'list'})

urlpatterns = [
    # Rutas para la vista del Administrador
    path('admin/', admin.site.urls),
    path('', views.redirect_to_login, name='redirect_to_login'),
    path('login/', views.custom_login, name='login'),
    path('logout/', views.custom_logout, name='logout'),
    path('inicio/', views.inicio, name='inicio'),
    path('frmCategorias/', views.categorias, name='categorias'),
    path('frmProductos/', views.productos, name='productos'),
    path('frmPedidos/', views.pedidos, name='pedidos'),
    path('frmEnvios/', views.envios, name='envios'),
    path('frmPagos/', views.pagos, name='pagos'),
    path('frmDevoluciones/', views.devoluciones, name='devoluciones'),
    
    # rutas para la paginacion de productos 
    path('productos-limit-offset/', producto_list_view, name='productos-limit-offset'),
    
    # rutas de la Api
    path('api/v1.0/', include(router.urls)),
    
    # rutas para carrito
    path('cart/', CartDetail.as_view(), name='cart-detail'),
    path('cart/<int:product_id>/', CartDetail.as_view(), name='cart-remove-item'),
    
    # esto es una prueba
    path('categorias/', CategoriasList.as_view(), name='categorias-list'),
    path('productos/', ProductosList.as_view(), name='productos-list'),
    
    # rutas para restablecer contraseña (Admin)
    path('validarCorreo/', views.restPasswordRequest , name='validarCorreo'),
    path('nuevaContra/', views.restPassword, name='nuevaContra'),
    path('mensajeCorreo/', views.mensajeCorreo, name='mensajeCorreo'),
    
    path('resetLink/', PasswordResetRequestView.as_view(), name='resetLink'),
    path('resetPassword/', PasswordResetView.as_view(), name='resetPassword'),
    
    # registro y login de usuarios
    path('registro/', RegistroUsuarioView.as_view(), name='registro'),
    path('accounts/login/', LoginUsuarioView.as_view(), name='login'),
    
    path('perfil/', views.perfil_usuario, name='perfil'),
    path('perfilApi/', views.perfil_usuario_api, name='perfilApi'),
]


if settings.DEBUG:
    urlpatterns += static (settings.MEDIA_URL, document_root = settings.MEDIA_ROOT)
