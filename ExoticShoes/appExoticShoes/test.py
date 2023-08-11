from django.test import TestCase
from .models import Categorias, ItemCarrito, Usuarios, Productos

class ItemCarritoTestCase(TestCase):
    def setUp(self):
        self.usuario = Usuarios.objects.create_user(
            username='testuser',
            password='testpassword',
            telefono='1234567890',
            FechaNacimiento='2000-01-01',
            direccion='Mi dirección'
        )
        categoria = Categorias.objects.create(nombre='Zapatos')
        self.producto = Productos.objects.create(
            nombre='Producto de prueba',
            descripcion='Descripción del producto de prueba',
            precio=99.99,
            cantidadEnInventario=10,
            estado=True,
            categoria=categoria
        )
        self.item = ItemCarrito.objects.create(
            usuario=self.usuario, 
            producto=self.producto, 
            cantidad=2, 
            total_precio=199.98, 
            subtotal=199.98
        )

    def test_subtotal_calculation(self):
        expected_subtotal = self.producto.precio * self.item.cantidad
        self.assertEqual(self.item.subtotal, expected_subtotal)

    def test_total_precio_calculation(self):
        expected_total_precio = self.producto.precio * self.item.cantidad
        self.assertEqual(self.item.total_precio, expected_total_precio)

    def test_save_method(self):
        categoria = Categorias.objects.create(nombre='Accesorios')
        new_product = Productos.objects.create(
            nombre='Producto de prueba2',
            descripcion='Descripción del producto de prueba',
            precio=99.99,
            cantidadEnInventario=10,
            estado=True,
            categoria=categoria
            )
        new_item = ItemCarrito(usuario=self.usuario, producto=new_product, cantidad=3)
        new_item.save()

        expected_subtotal = new_product.precio * new_item.cantidad
        self.assertEqual(new_item.subtotal, expected_subtotal)
        self.assertEqual(new_item.total_precio, expected_subtotal)

    def test_update_quantity(self):
        new_quantity = 5
        self.item.cantidad = new_quantity
        self.item.save()

        expected_subtotal = self.producto.precio * new_quantity
        self.assertEqual(self.item.subtotal, expected_subtotal)
        self.assertEqual(self.item.total_precio, expected_subtotal)