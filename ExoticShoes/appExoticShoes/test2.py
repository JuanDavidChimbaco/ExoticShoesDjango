from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status
from .models import Usuarios, Categorias, Productos, Pedidos, DetallePedido, Pago, Envio, Devoluciones
from .serializers import UsuariosSerializer, CategoriasSerializer, ProductosSerializer, PedidosSerializer, DetallePedidoSerializer, PagoSerializer, EnvioSerializer, DevolucionesSerializer

class APITestCases(APITestCase):
    def setUp(self):
        # Crea algunos datos de prueba para tus modelos
        # Puedes crear instancias de tus modelos y guardarlos en la base de datos
        # Aquí hay un ejemplo con Usuarios y Productos:

        self.usuario = Usuarios.objects.create_user(username='testuser', password='testpassword', telefono='1234567890', FechaNacimiento='1990-01-01', direccion='Test Address')
        self.categoria = Categorias.objects.create(nombre='Electrónicos')
        self.producto = Productos.objects.create(nombre='Laptop', descripcion='Laptop de prueba', precio=1000, cantidadEnInventario=10, estado=True, categoria=self.categoria)

    def test_usuarios_list(self):
        # Prueba para verificar que se pueda obtener una lista de usuarios
        url = '/api/v1.0/usuarios/'  # Actualiza esta URL con la ruta correcta de tu vista UsuariosViewSet
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)  # Verifica que se haya creado un usuario en la base de datos y se devuelva en la lista

    def test_productos_list(self):
        # Prueba para verificar que se pueda obtener una lista de productos activos
        url = '/api/v1.0/productos/'  # Actualiza esta URL con la ruta correcta de tu vista ProductosViewSet
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)  # Verifica que se haya creado un producto activo en la base de datos y se devuelva en la lista

    def test_crear_producto(self):
        # Prueba para verificar que se pueda crear un nuevo producto
        url = '/api/v1.0/productos/'  # Actualiza esta URL con la ruta correcta de tu vista ProductosViewSet
        data = {
            'nombre': 'Nuevo Producto',
            'descripcion': 'Descripción de nuevo producto',
            'precio': 500,
            'cantidadEnInventario': 20,
            'estado': True,
            'categoria': self.categoria.id,
        }
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Productos.objects.count(), 2)  # Verifica que se haya creado un nuevo producto en la base de datos

# Agrega más pruebas según las funcionalidades que deseas probar en tu API
# Puedes probar las otras vistas: CategoriasViewSet, PedidosViewSet, DetallePedidoViewSet, PagoViewSet, EnvioViewSet, DevolucionesViewSet, etc.

