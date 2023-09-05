from datetime import timezone
from django.db import models
from django.contrib.auth.models import User, Group, AbstractUser
from django.core.validators import MinValueValidator
from django.conf import settings
from django.core.exceptions import ValidationError

# cliente_group, created = Group.objects.get_or_create(name='cliente')
# admin_group, created = Group.objects.get_or_create(name='admin')

# ================================= Usuario ==============================================
class Usuario(User):
    telefono = models.CharField(max_length=45)
    fechaNacimiento = models.DateField()
    direccion = models.CharField(max_length=45)
    fotoPerfil = models.ImageField(upload_to='perfiles/', blank=True, null=True)
     
    def __str__(self):
        return self.username
    
# ================================= Categoria ==============================================
class Categoria(models.Model):
    nombre = models.CharField(max_length=45,unique=True)
    imagenCategoria = models.ImageField(upload_to='categorias/', blank=True, null=True)
    def __str__(self):
        return self.nombre 
    
# ================================= Producto ==============================================
ESTADOPRODUCTO = (
    (True, 'Activo'),
    (False, 'Desactivado'),
)
class Producto(models.Model):
    nombre = models.CharField(max_length=45)
    descripcion = models.CharField(max_length=45)
    precio = models.DecimalField(max_digits=10, decimal_places=2)
    existencias = models.IntegerField()
    estado = models.BooleanField(choices=ESTADOPRODUCTO, default=True)
    categoria = models.ForeignKey(Categoria, on_delete=models.PROTECT)

    def __str__(self):
        return self.nombre

class ImagenProducto(models.Model):
    producto = models.ForeignKey(Producto, related_name='imagenes', on_delete=models.PROTECT)
    imagen = models.ImageField(upload_to='productos/')
    
    def __str__(self):
        return self.producto.nombre + ' - Imagen'

TALLAS = (
    ('S', 'S'),
    ('M', 'M'),
    ('L', 'L'),
    ('XL', 'XL'),
    ('XXL', 'XXL'),
    ('28', '28'),
    ('30', '30'),
    ('32', '32'),
    ('34', '34'),
    ('35', '35'),
    ('36', '36'),
    ('37', '37'),
    ('38', '38'),
    ('39', '39'),
    ('40', '40'),
    ('41', '41'),
)
class Talla(models.Model):
    nombre = models.CharField(max_length=3, choices=TALLAS)  # Ejemplo: "S", "M", "L", etc.

    def __str__(self):
        return self.nombre

class ProductoConTalla(models.Model):
    producto = models.ForeignKey(Producto, on_delete=models.PROTECT)
    talla = models.ForeignKey(Talla, on_delete=models.PROTECT)
    existencias = models.IntegerField()

    def __str__(self):
        return f"{self.producto.nombre} - Talla {self.talla.nombre}"
    
# ================================= Pedido ============================================== 
ESTADOPEDIDO = (
    ('pendiente', 'Pendiente'),
    ('confirmado', 'Confirmado'),
    ('devuelto', 'Devuelto'),
) 
class Pedido(models.Model):
    codigoPedido = models.CharField(max_length=45 , unique=True)
    fechaPedido = models.DateField()
    usuario = models.ForeignKey(Usuario, on_delete=models.PROTECT)
    total = models.FloatField()
    estadoPedido = models.CharField(max_length=50)
        
    def __str__(self):
        return f"Pedido {self.codigoPedido}"


class DetallePedido(models.Model):
    pedido = models.ForeignKey(Pedido, on_delete=models.PROTECT)
    producto = models.ForeignKey(Producto, on_delete=models.PROTECT)
    cantidad = models.IntegerField()
    subtotal = models.FloatField()  
    def __str__(self):
        return f"Detalle de pedido {self.pedido.codigoPedido}"

# ================================= Pago ==============================================
METODOS = (
        ('tarjetaCredito', 'Tarjeta de Credito'),
        ('tarjetaDebito', 'Tarjeta de Debito'),
        ('contraEntrega', 'Contra entrega'),
        ('PagoEfectivo', 'Pago en Efectivo'),
        ('PSE', 'Pago Seguro en Linea(PSE)'),
    )
ESTADOPAGO = (
        ('pendiente', 'Pendiente'),
        ('pagado', 'Pagado'),
        ('rechazado', 'Rechazado'),
        ('cancelado', 'Cancelado')
    )
class Pago(models.Model):
    metodo = models.CharField(max_length=45, choices=METODOS)
    fechaPago = models.DateTimeField()
    estadoPago = models.CharField(max_length=45, choices=ESTADOPAGO, default='pendiente')
    confirmado = models.BooleanField(default=False) # Nuevo campo para la confirmación
    pedidos = models.ForeignKey(Pedido, on_delete=models.PROTECT)

    def __str__(self):
        return f"Pago {self.id}"

# ================================= Envio ==============================================
SERVICIOENVIO = (
    ('Interrapidisimo', 'Interrapidisimo'),
    ('PuntoFisico', 'Punto Fisico'),
)
ESTADOENVIO = (
    ('pendiente', 'Pendiente'),
    ('enviado', 'Enviado'),
    ('entregado', 'Entregado'),
    ('cancelado', 'Cancelado'),
)
class Envio(models.Model):
    servicioEnvio = models.CharField(max_length=30, choices=SERVICIOENVIO)
    DireccionEnvio = models.CharField(max_length=45)
    fechaEnvio = models.DateTimeField()
    estadoPago = models.ForeignKey(Pago, on_delete=models.PROTECT)
    estado = models.CharField(max_length=45, choices=ESTADOENVIO, default='pendiente' )

    def clean(self):
        # Verificar si el método de pago es "Contra entrega"
        if self.estadoPago and self.estadoPago.metodo == 'contraEntrega':
            # Si es "Contra entrega", forzar el servicio de envío a "Interrapidisimo"
            self.servicioEnvio = 'Interrapidisimo'
        super().clean()


# ================================= Devolucion ==============================================
class Devolucione(models.Model):
    pedido = models.ForeignKey(Pedido, on_delete=models.CASCADE)
    motivo = models.CharField(max_length=255)
    detalles = models.TextField(blank=True, null=True)
    fechaDevolucion = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Devolución del Pedido {self.pedido.id}"
    
# ================================= Carrito ==============================================
class Cart(models.Model):
    products = models.ManyToManyField(Producto, through='CartItem')

class CartItem(models.Model):
    cart = models.ForeignKey(Cart, on_delete=models.PROTECT)
    product = models.ForeignKey(Producto, on_delete=models.PROTECT)
    quantity = models.PositiveIntegerField(validators=[MinValueValidator(1)])