from datetime import timezone
from django.db import models
from django.contrib.auth.models import User, Group, AbstractUser
from django.core.validators import MinValueValidator
from django.conf import settings

ESTADO_CHOICES = (
    (True, 'Activo'),
    (False, 'Borrado'),
)

cliente_group, created = Group.objects.get_or_create(name='cliente')
admin_group, created = Group.objects.get_or_create(name='admin')


class Usuario(User):
    telefono = models.CharField(max_length=45)
    fechaNacimiento = models.DateField()
    direccion = models.CharField(max_length=45)
     
    def __str__(self):
        return self.username

class Categoria(models.Model):
    nombre = models.CharField(max_length=45,unique=True)

    def __str__(self):
        return self.nombre 

class Producto(models.Model):
    nombre = models.CharField(max_length=45)
    descripcion = models.CharField(max_length=45)
    precio = models.DecimalField(max_digits=10, decimal_places=2)
    existencias = models.IntegerField()
    foto = models.ImageField(upload_to='productos/', blank=True, null=True)
    estado = models.BooleanField(choices=ESTADO_CHOICES, default=True)
    categoria = models.ForeignKey(Categoria, on_delete=models.PROTECT)

    def __str__(self):
        return self.nombre


class Pedido(models.Model):
    codigoPedido = models.CharField(max_length=45 , unique=True)
    fechaPedido = models.DateField()
    usuario = models.ForeignKey(Usuario, on_delete=models.PROTECT)
    total = models.FloatField() 
        
    def __str__(self):
        return f"Pedido {self.codigoPedido}"


class DetallePedido(models.Model):
    pedido = models.ForeignKey(Pedido, on_delete=models.PROTECT)
    producto = models.ForeignKey(Producto, on_delete=models.PROTECT)
    cantidad = models.IntegerField()
    subtotal = models.FloatField()  
    def __str__(self):
        return f"Detalle de pedido {self.pedido.codigoPedido}"


class Pago(models.Model):
    METODO_CHOICES = (
        ('tarjeta', 'Tarjeta'),
        ('contraEntrega', 'Contra entrega'),
        ('PSE', 'PSE'),
    )

    metodo = models.CharField(max_length=45, choices=METODO_CHOICES)
    monto = models.FloatField()
    fecha = models.DateTimeField()
    estado = models.CharField(max_length=45, null=True)
    pedidos = models.ForeignKey(Pedido, on_delete=models.CASCADE)

    def __str__(self):
        return f"Pago {self.id}"


class Envio(models.Model):
    servicioEnvio = models.CharField(max_length=45)
    DireccionEnv = models.CharField(max_length=45)
    fechaEnvio = models.DateTimeField()
    fechaEntrega = models.DateTimeField()
    estadoPago = models.ForeignKey(Pago, on_delete=models.CASCADE, null=True)
    estado = models.CharField(max_length=45, null=True)

    def __str__(self):
        return f"Envío {self.id}"
    
    def save(self, *args, **kwargs):
        if not self.fechaEnvio:
            self.fechaEnvio = timezone.now()
        if not self.fechaEntrega:
            self.fechaEntrega = timezone.now() + timezone.timedelta(days=1)  # Ejemplo: fechaEntrega es un día después
        super().save(*args, **kwargs)


class Devolucione(models.Model):
    fechaDevolucion = models.DateTimeField(null=True)
    motivo = models.CharField(max_length=200)
    envio = models.ForeignKey(Envio, on_delete=models.CASCADE, null=True)
    productosDevueltos = models.CharField(max_length=45, null=True)
    cantidadDevuelta = models.IntegerField(null=True)
    pago = models.ForeignKey(Pago, on_delete=models.CASCADE, null=True)

    def __str__(self):
        return f"Devolución {self.id}"
    
    def save(self, *args, **kwargs):
        if not self.fechaDevolucion:
            self.fechaDevolucion = timezone.now()
        super().save(*args, **kwargs)

class Cart(models.Model):
    user = models.OneToOneField(Usuario, on_delete=models.PROTECT)
    products = models.ManyToManyField(Producto, through='CartItem')

class CartItem(models.Model):
    cart = models.ForeignKey(Cart, on_delete=models.PROTECT)
    product = models.ForeignKey(Producto, on_delete=models.PROTECT)
    quantity = models.PositiveIntegerField(validators=[MinValueValidator(1)])