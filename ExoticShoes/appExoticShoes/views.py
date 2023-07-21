import http
from django.shortcuts import render, redirect
from rest_framework import viewsets
from .models import Usuarios, Categorias, Productos, Pedidos, DetallePedido, Pago, Envio, Devoluciones
from .serializers import UsuariosSerializer, CategoriasSerializer, ProductosSerializer, PedidosSerializer,DetallePedidoSerializer,PagoSerializer,EnvioSerializer, DevolucionesSerializer
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login , logout

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

# ------------------- Vistas -------------------

def custom_login(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('inicio')
    return render(request, 'inicio_sesion.html')


@login_required(login_url='/')
def inicio(request):
    return render (request,"dashboard.html",{})

@login_required(login_url='/')
def categorias(request):
    return render (request, "frmCategorias.html",{})

@login_required(login_url='/')
def productos(request):
    return render (request,'frmProductos.html',{})

@login_required(login_url='/')
def pedidos(request):
    return render (request,'frmPedidos.html',{})

@login_required(login_url='/')
def envios(request):
    return render (request,'frmEnvios.html',{})

@login_required(login_url='/')
def custom_logout(request):
    logout(request)
    return redirect('login')
