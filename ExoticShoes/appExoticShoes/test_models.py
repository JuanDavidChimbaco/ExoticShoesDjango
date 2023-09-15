from django.conf import settings
from django.test import TestCase
from .models import Usuario, Categoria, Producto, Talla, Pedido, DetallePedido, Pago, Envio, Devolucione, Cart, CartItem
from django.core.files.uploadedfile import SimpleUploadedFile
from decimal import Decimal
from datetime import date ,datetime

class ModelTestCase(TestCase):
    def setUp(self):
        self._old_use_tz = settings.USE_TZ
        settings.USE_TZ = False
        # Create a user for testing Usuario model
        self.usuario = Usuario.objects.create_user(
            username='testuser', 
            password='testpassword',
            telefono='123456789',
            fechaNacimiento=date(1990, 1, 1),
            direccion='Test Address',
            fotoPerfil=SimpleUploadedFile("test.jpg", b"file_content"),
        )

        # Create a Categoria instance
        self.categoria = Categoria.objects.create(
            nombre='Test Categoria',
            imagen = SimpleUploadedFile('test.jpg',b"file_content"))

        # Create a Producto instance
        self.producto = Producto.objects.create(
            nombre='Test Producto',
            descripcion='Test Description',
            precio=Decimal('10.99'),
            categoria=self.categoria,
        )

        # Create a Talla instance
        self.talla = Talla.objects.create(
            talla='XL',
            cantidad=10,
            producto=self.producto,
        )

        # Create a Pedido instance
        self.pedido = Pedido.objects.create(
            codigoPedido='12345',
            fechaPedido=date(2023, 1, 1),
            usuario=self.usuario,
            total=Decimal('50.00'),
            estadoPedido='pendiente',
        )

        # Create a DetallePedido instance
        self.detalle_pedido = DetallePedido.objects.create(
            pedido=self.pedido,
            producto=self.producto,
            talla=self.talla,
            cantidad=2,
            subtotal=Decimal('21.98'),
        )

        # Create a Pago instance
        self.pago = Pago.objects.create(
            metodo='tarjetaCredito',
            fechaPago=datetime(2023,1,1,1,1,1),
            estadoPago='pendiente',
            confirmado=False,
            pedidos=self.pedido,
        )

        # Create an Envio instance
        self.envio = Envio.objects.create(
            servicioEnvio='Interrapidisimo',
            DireccionEnvio='Test Address',
            fechaEnvio=date(2023,1,2),
            estadoPago=self.pago,
            estado='pendiente',
        )

        # Create a Devolucione instance
        self.devolucion = Devolucione.objects.create(
            pedido=self.pedido,
            motivo='Defective product',
            detalles='Test details',
        )

        # Create a Cart instance
        self.cart = Cart.objects.create()

        # Create a CartItem instance
        self.cart_item = CartItem.objects.create(
            cart=self.cart,
            product=self.producto,
            quantity=3,
        )

    def test_models(self):
        # Test Usuario model
        self.assertEqual(str(self.usuario), 'testuser')
        self.assertEqual(self.usuario.username, 'testuser')
        self.assertTrue(self.usuario.is_active)

        # Test Categoria model
        self.assertEqual(str(self.categoria), 'Test Categoria')
        self.assertEqual(self.categoria.nombre, 'Test Categoria')

        # Test Producto model
        self.assertEqual(str(self.producto), 'Test Producto')
        self.assertEqual(self.producto.nombre, 'Test Producto')
        self.assertEqual(self.producto.precio, Decimal('10.99'))
        
        # Test Talla model
        self.assertEqual(str(self.talla), 'Test Producto Talla: XL')

        # Test Pedido model
        self.assertEqual(str(self.pedido), 'Pedido 12345')

        # Test DetallePedido model
        self.assertEqual(str(self.detalle_pedido), 'Detalle de pedido 12345')

        # Test Pago model
        self.assertEqual(str(self.pago), 'Pago {}'.format(self.pago.id))

        # Test Envio model
        self.assertEqual(str(self.envio), 'Envio {}'.format(self.envio.id))

        # Test Devolucione model
        self.assertEqual(str(self.devolucion), 'Devolución del Pedido {}'.format(self.pedido.id))

        # Test Cart model
        self.assertEqual(str(self.cart), 'Cart {}'.format(self.cart.id))

        # Test CartItem model
        self.assertEqual(str(self.cart_item), 'CartItem {}'.format(self.cart_item.id))
        
    def tearDown(self):
        settings.USE_TZ = self._old_use_tz

