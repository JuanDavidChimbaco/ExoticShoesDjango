from django.contrib import admin
from django.conf import settings
from django.conf.urls.static import static
from django.urls import include, path
from rest_framework import routers
from appExoticShoes.views import ProductosListView , ProductosFiltradosPorCategoriaViewSet 
from appExoticShoes import views

# router para las rutas de la Api
router = routers.DefaultRouter()
router.register(r'usuarios', views.UsuariosViewSet)
router.register(r'categorias', views.CategoriasViewSet)
router.register(r'productos', views.ProductosViewSet)
router.register(r'productos-filtrados', ProductosFiltradosPorCategoriaViewSet, basename='productos-filtrados')
router.register(r'carrito', views.ItemCarritoViewSet, basename='carrito')
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
    
    
    # rutas para la vista del cliente
    path('convertir-a-pedido/', views.convertir_a_pedido, name='convertir_a_pedido'),
    path('api/procesar-pago/<int:pedido_id>/', views.ProcesarPagoView.as_view(), name='procesar_pago_api'),
    path('carrito/', views.vista_del_carrito, name='vista_del_carrito'),
    path('agregar-al-carrito/<int:producto_id>/', views.agregar_al_carrito, name='agregar_al_carrito'),
    path('eliminar-del-carrito/<int:item_id>/', views.eliminar_del_carrito, name='eliminar_del_carrito'),
    path('productos-limit-offset/', producto_list_view, name='productos-limit-offset'),
    
    # rutas de la Api
    path('api/v1.0/', include(router.urls)),
]

if settings.DEBUG:
    urlpatterns += static (settings.MEDIA_URL, document_root = settings.MEDIA_ROOT)
