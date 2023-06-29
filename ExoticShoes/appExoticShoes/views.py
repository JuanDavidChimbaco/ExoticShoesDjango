from django.shortcuts import render
from rest_framework import viewsets
from .models import Usuarios, Categorias, Productos, Pedidos, DetallePedido, Pago, Envio, Devoluciones
from .serializers import UsuariosSerializer, CategoriasSerializer, ProductosSerializer, PedidosSerializer,DetallePedidoSerializer,PagoSerializer,EnvioSerializer, DevolucionesSerializer

class UsuariosViewSet(viewsets.ModelViewSet):
    queryset = Usuarios.objects.all()
    serializer_class = UsuariosSerializer

class CategoriasViewSet(viewsets.ModelViewSet):
    queryset = Categorias.objects.all()
    serializer_class = CategoriasSerializer

class ProductosViewSet(viewsets.ModelViewSet):
    queryset = Productos.objects.all()
    serializer_class = ProductosSerializer

class PedidosViewSet(viewsets.ModelViewSet):
    queryset = Pedidos.objects.all()
    serializer_class = PedidosSerializer

class DetallePedidoViewSet(viewsets.ModelViewSet):
    queryset = DetallePedido.objects.all()
    serializer_class = DetallePedidoSerializer
    
class PagoViewSet(viewsets.ModelViewSet):
    queryset = Pago.objects.all()
    serializer_class = PagoSerializer
    
class EnvioViewSet(viewsets.ModelViewSet):
    queryset = Envio.objects.all()
    serializer_class = EnvioSerializer
    
class DevolucionesViewSet(viewsets.ModelViewSet):
    queryset = Devoluciones.objects.all()
    serializer_class = DevolucionesSerializer


def inicio(request):
    return render (request,"dashboard.html",{})

def categorias(request):
    return render (request, "frmCategorias.html",{})

def productos(request):
    return render (request,'frmProductos.html',{})

def pedidos(request):
    return render (request,'frmPedidos.html',{})

