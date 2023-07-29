"""
URL configuration for ExoticShoes project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.conf import settings
from django.conf.urls.static import static
from django.urls import include, path
from rest_framework import routers
from appExoticShoes import views

router = routers.DefaultRouter()
router.register(r'usuarios', views.UsuariosViewSet)
router.register(r'categorias', views.CategoriasViewSet)
router.register(r'productos', views.ProductosViewSet)
router.register(r'carrito', views.ItemCarritoViewSet, basename='carrito')
router.register(r'pedidos', views.PedidosViewSet)
router.register(r'detallePedidos', views.DetallePedidoViewSet,basename='detallepedido')
router.register(r'pago', views.PagoViewSet)
router.register(r'envio', views.EnvioViewSet)
router.register(r'devoluciones', views.DevolucionesViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.redirect_to_login, name='redirect_to_login'),
    path('login/', views.custom_login, name='login'),
    path('logout/', views.custom_logout, name='logout'),
    path('inicio/', views.inicio, name='inicio'),
    path('frmCategorias/', views.categorias, name='categorias'),
    path('frmProductos/', views.productos, name='productos'),
    path('frmPedidos/', views.pedidos, name='pedidos'),
    path('frmEnvios/', views.envios, name='envios'),
    path('convertir-a-pedido/', views.convertir_a_pedido, name='convertir_a_pedido'),
    path('api/procesar-pago/<int:pedido_id>/', views.ProcesarPagoView.as_view(), name='procesar_pago_api'),
    
    path('agregar-al-carrito/<int:producto_id>/', views.agregar_al_carrito, name='agregar_al_carrito'),
    path('eliminar-del-carrito/<int:item_id>/', views.eliminar_del_carrito, name='eliminar_del_carrito'),
    path('carrito/', views.vista_del_carrito, name='vista_del_carrito'),
    
    path('api/v1.0/', include(router.urls)),
]

if settings.DEBUG:
    urlpatterns += static (settings.MEDIA_URL, document_root = settings.MEDIA_ROOT)
