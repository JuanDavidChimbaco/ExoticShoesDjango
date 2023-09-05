from django.contrib import admin 
from django.conf import settings
from django.conf.urls.static import static
from django.urls import include, path

from rest_framework.routers import DefaultRouter
from appExoticShoes.views import ProductosListView , ProductosFiltradosPorCategoriaViewSet, CategoriasList, ProductosList , PasswordResetRequestView, PasswordResetView,custom_404_view

from appExoticShoes import views



# router para las rutas de la Api
router = DefaultRouter()
router.register(r'usuarios', views.UsuariosViewSet, basename='usuarios')
router.register(r'registro', views.RegistroClienteViewSet , basename='registro')
router.register(r'carrito', views.CartViewSet , basename='carrito')
router.register(r'categorias', views.CategoriasViewSet , basename='categorias')
router.register(r'productos', views.ProductosViewSet, basename='productos')
router.register(r'productos-filtrados', ProductosFiltradosPorCategoriaViewSet, basename='productos-filtrados')
router.register(r'pedidos', views.PedidosViewSet, basename='pedidos')
router.register(r'detallePedidos', views.PedidoDetailViewSet,basename='detallePedido')
router.register(r'pago', views.PagoViewSet,basename='pago')
router.register(r'envio', views.EnvioViewSet, basename='envio')
router.register(r'devoluciones', views.DevolucionesViewSet , basename='devoluciones')

# lista de productos para la vista del cliente
producto_list_view = ProductosListView.as_view({'get': 'list'})

urlpatterns = [
    # Rutas para la vista del Administrador
    path('admin/', admin.site.urls),
    path('', views.redirect_to_login, name='redirect_to_login'),
    path('inicio/', views.index, name='inicio'),
    path('dashboard/', views.dashboard, name='dashboard'),
    path('frmCategorias/', views.categorias, name='categorias'),
    path('frmProductos/', views.productos, name='productos'),
    path('frmPedidos/', views.pedidos, name='pedidos'),
    path('frmEnvios/', views.envios, name='envios'),
    path('frmPagos/', views.pagos, name='pagos'),
    path('frmDevoluciones/', views.devoluciones, name='devoluciones'),
     path('api/login/', views.custom_login, name='custom_login'),

    # rutas de la Api
    path('api/v1.0/', include(router.urls)),
    
    # rutas para la paginacion de productos 
    path('api/v1.0/productos-limit-offset/', producto_list_view, name='productos-limit-offset'),
   
    
    # esto es una prueba
    path('categorias/', CategoriasList.as_view(), name='categorias-list'),
    path('productos/', ProductosList.as_view(), name='productos-list'),
    
    path('inicioCliente/', views.inicioCliente, name='inicioCliente'),
    path('registroCliente/', views.registroCliente, name='registroCliente'),
    
    # rutas para restablecer contraseña (Admin)
    path('validarCorreo/', views.restPasswordRequest , name='validarCorreo'),
    path('nuevaContra/', views.restPassword, name='nuevaContra'),
    path('mensajeCorreo/', views.mensajeCorreo, name='mensajeCorreo'),
    
    path('resetLink/', PasswordResetRequestView.as_view(), name='resetLink'),
    path('resetPassword/', PasswordResetView.as_view(), name='resetPassword'),
    
    #login de usuarios (Cliente)
    path('inicioSesion/', views.LoginClienteView.as_view(), name='inicioSesion'),
    path('custom_logout/', views.custom_logout, name='custom_logout'),
    
    # perfil de usuario(Admin)
    path('perfil/', views.perfil_usuario, name='perfil'),
    path('api/v1.0/perfilApi/', views.perfil_usuario_api, name='perfilApi'),
    
    # path('pedidos/', PedidoListCreateView.as_view(), name='pedido-list-create'),
    
]

# handler404 = custom_404_view

if settings.DEBUG:
    urlpatterns += static (settings.MEDIA_URL, document_root = settings.MEDIA_ROOT)
