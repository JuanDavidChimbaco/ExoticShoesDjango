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
from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import include, path
from rest_framework import routers
from appExoticShoes import views
from appExoticShoes.views import inicio,roles,productos

router = routers.DefaultRouter()
router.register(r'roles', views.RolesViewSet)
router.register(r'usuarios', views.UsuariosViewSet)
router.register(r'categorias', views.CategoriasViewSet)
router.register(r'productos', views.ProductosViewSet)
router.register(r'pedidos', views.PedidosViewSet)
router.register(r'detallePedidos', views.DetallePedidoViewSet)
router.register(r'pago', views.PagoViewSet)
router.register(r'envio', views.EnvioViewSet)
router.register(r'devoluciones', views.DevolucionesViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('inicio/', inicio),
    path('frmRoles/', roles),
    path('frmProductos/', productos),
    path('api/', include(router.urls)),
]

if settings.DEBUG:
    urlpatterns += static (settings.MEDIA_URL, document_root = settings.MEDIA_ROOT)
