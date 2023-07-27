from pyexpat.errors import messages
from django.shortcuts import render, redirect, get_object_or_404
from rest_framework import viewsets
from .models import (
    Usuarios,
    Categorias,
    Productos,
    Pedidos,
    DetallePedido,
    Pago,
    Envio,
    Devoluciones,
)
from .serializers import (
    UsuariosSerializer,
    CategoriasSerializer,
    ProductosSerializer,
    PedidosSerializer,
    DetallePedidoSerializer,
    PagoSerializer,
    EnvioSerializer,
    DevolucionesSerializer,
)
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
import os
from django.conf import settings
from rest_framework import viewsets, status
from rest_framework.response import Response


class UsuariosViewSet(viewsets.ModelViewSet):
    queryset = Usuarios.objects.all()
    serializer_class = UsuariosSerializer


class CategoriasViewSet(viewsets.ModelViewSet):
    queryset = Categorias.objects.all()
    serializer_class = CategoriasSerializer


class ProductosViewSet(viewsets.ModelViewSet):
    # trae todos los productos que esten activos
    queryset = Productos.objects.filter(estado=True)
    serializer_class = ProductosSerializer
    
    def perform_destroy(self, instance):
        instance.estado = False
        instance.save()


class PedidosViewSet(viewsets.ModelViewSet):
    queryset = Pedidos.objects.all()
    serializer_class = PedidosSerializer


class DetallePedidoViewSet(viewsets.ModelViewSet):
    serializer_class = DetallePedidoSerializer
    queryset = DetallePedido.objects.all()


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


def redirect_to_login(request):
    return redirect("login")


def custom_login(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(username=username, password=password)
        if user is not None:
            login(request, user)
            request.session['login_success_message'] = '¡Login exitoso!'
            return render(request,'inicio_sesion.html', {'login_success_message': request.session['login_success_message']})
        else:
            error_message = "Usuario o contraseña incorrectos. Por favor, inténtalo de nuevo."
            return render(request, 'inicio_sesion.html', {'error_message': error_message})
    return render(request, 'inicio_sesion.html')


@login_required(login_url="login")
def inicio(request):
    return render(request, "dashboard.html", {})


@login_required(login_url="/")
def categorias(request):
    return render(request, "frmCategorias.html", {})


@login_required(login_url="/")
def productos(request):
    return render(request, "frmProductos.html", {})


@login_required(login_url="/")
def pedidos(request):
    return render(request, "frmPedidos.html", {})


@login_required(login_url="/")
def envios(request):
    return render(request, "frmEnvios.html", {})


@login_required(login_url="/")
def custom_logout(request):
    logout(request)
    return redirect("login")
