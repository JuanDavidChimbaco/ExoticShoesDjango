from django.test import TestCase
from .models import Usuarios, Categorias, Productos, Pedidos, DetallePedido, Pago, Envio, Devoluciones

class UsuariosModelTestCase(TestCase):
    def test_creacion_usuario(self):
        usuario = Usuarios.objects.create_user(
            username='testuser',
            password='testpassword',
            telefono='1234567890',
            FechaNacimiento='2000-01-01',
            direccion='Mi dirección'
        )
        self.assertEqual(usuario.username, 'testuser')
        self.assertTrue(usuario.is_active)

    # Agregar más pruebas para el modelo Usuarios...

class CategoriasModelTestCase(TestCase):
    def test_creacion_categoria(self):
        categoria = Categorias.objects.create(nombre='Zapatos')
        self.assertEqual(categoria.nombre, 'Zapatos')

    # Agregar más pruebas para el modelo Categorias...

class ProductosModelTestCase(TestCase):
    def test_creacion_producto(self):
        categoria = Categorias.objects.create(nombre='Zapatos')
        producto = Productos.objects.create(
            nombre='Producto de prueba',
            descripcion='Descripción del producto de prueba',
            precio=99.99,
            cantidadEnInventario=10,
            estado=True,
            categoria=categoria
        )
        self.assertEqual(producto.nombre, 'Producto de prueba')
        self.assertEqual(producto.precio, 99.99)

    # Agregar más pruebas para el modelo Productos...

class PedidosModelTestCase(TestCase):
    def test_creacion_pedido(self):
        usuario = Usuarios.objects.create_user(
            username='testuser',
            password='testpassword',
            telefono='1234567890',
            FechaNacimiento='2000-01-01',
            direccion='Mi dirección'
        )
        pedido = Pedidos.objects.create(fechaPedido='2023-07-23', usuario=usuario)
        self.assertEqual(str(pedido), 'Pedido 5')

    # Agregar más pruebas para el modelo Pedidos...

class DetallePedidoModelTestCase(TestCase):
    def test_creacion_detalle_pedido(self):
        categoria = Categorias.objects.create(nombre='Zapatos')
        producto = Productos.objects.create(
            nombre='Producto de prueba',
            descripcion='Descripción del producto de prueba',
            precio=99.99,
            cantidadEnInventario=10,
            estado=True,
            categoria=categoria
        )
        usuario = Usuarios.objects.create_user(
            username='testuser',
            password='testpassword',
            telefono='1234567890',
            FechaNacimiento='2000-01-01',
            direccion='Mi dirección'
        )
        pedido = Pedidos.objects.create(fechaPedido='2023-07-23', usuario=usuario)
        detalle_pedido = DetallePedido.objects.create(
            pedido=pedido,
            producto=producto,
            cantidad=2,
            subtotal=199.98
        )
        self.assertEqual(str(detalle_pedido), 'Detalle de pedido 1')

    # Agregar más pruebas para el modelo DetallePedido...

class PagoModelTestCase(TestCase):
    def test_creacion_pago(self):
        usuario = Usuarios.objects.create_user(
            username='testuser',
            password='testpassword',
            telefono='1234567890',
            FechaNacimiento='2000-01-01',
            direccion='Mi dirección'
        )
        pedido = Pedidos.objects.create(fechaPedido='2023-07-23', usuario=usuario)
        pago = Pago.objects.create(
            metodo='tarjeta',
            monto=100.00,
            fecha='2023-07-23 12:00:00',
            estado='Aprobado',
            pedidos=pedido
        )
        self.assertEqual(str(pago), 'Pago 3')

    # Agregar más pruebas para el modelo Pago...

class EnvioModelTestCase(TestCase):
    def test_creacion_envio(self):
        usuario = Usuarios.objects.create_user(
            username='testuser',
            password='testpassword',
            telefono='1234567890',
            FechaNacimiento='2000-01-01',
            direccion='Mi dirección'
        )
        pedido = Pedidos.objects.create(fechaPedido='2023-07-23', usuario=usuario)
        pago = Pago.objects.create(
            metodo='tarjeta',
            monto=100.00,
            fecha='2023-07-23 12:00:00',
            estado='Aprobado',
            pedidos=pedido
        )
        envio = Envio.objects.create(
            servicioEnvio='Servicio de envío',
            DireccionEnv='Dirección de envío',
            fechaEnvio='2023-07-23 12:00:00',
            fechaEntrega='2023-07-24 12:00:00',
            estadoPago=pago,
            estado='En tránsito'
        )
        self.assertEqual(str(envio), 'Envío 2')

    # Agregar más pruebas para el modelo Envio...

class DevolucionesModelTestCase(TestCase):
    def test_creacion_devolucion(self):
        usuario = Usuarios.objects.create_user(
            username='testuser',
            password='testpassword',
            telefono='1234567890',
            FechaNacimiento='2000-01-01',
            direccion='Mi dirección'
        )
        pedido = Pedidos.objects.create(fechaPedido='2023-07-23', usuario=usuario)
        pago = Pago.objects.create(
            metodo='tarjeta',
            monto=100.00,
            fecha='2023-07-23 12:00:00',
            estado='Aprobado',
            pedidos=pedido
        )
        envio = Envio.objects.create(
            servicioEnvio='Servicio de envío',
            DireccionEnv='Dirección de envío',
            fechaEnvio='2023-07-23 12:00:00',
            fechaEntrega='2023-07-24 12:00:00',
            estadoPago=pago,
            estado='En tránsito'
        )
        devolucion = Devoluciones.objects.create(
            fechaDevolucion='2023-07-25 12:00:00',
            motivo='Producto defectuoso',
            envio=envio,
            productosDevueltos='Producto de prueba',
            cantidadDevuelta=1,
            pago=pago
        )
        self.assertEqual(str(devolucion), 'Devolución 1')

    # Agregar más pruebas para el modelo Devoluciones...
