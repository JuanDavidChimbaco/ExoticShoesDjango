from django.db import models

# Create your models here.
from django.db import models

class Roles(models.Model):
    nombre = models.CharField(max_length=45)

    def __str__(self):
        return self.nombre


class Usuarios(models.Model):
    nombre = models.CharField(max_length=45)
    apellido = models.CharField(max_length=45)
    correo = models.CharField(max_length=45,unique=True)
    contraseña = models.CharField(max_length=45)
    telefono = models.CharField(max_length=45)
    FechaNacimiento = models.DateField(null=True)
    direccion = models.CharField(max_length=45)
    rol = models.ForeignKey(Roles, on_delete=models.SET_NULL, null=True)

    def __str__(self):
        return self.nombre


class Categorias(models.Model):
    nombre = models.CharField(max_length=45,unique=True)

    def __str__(self):
        return self.nombre


class Productos(models.Model):
    nombre = models.CharField(max_length=45)
    descripcion = models.CharField(max_length=45)
    precio = models.FloatField()
    cantidadEnInventario = models.IntegerField()
    foto = models.ImageField(upload_to='productos/', blank=True, null=True)
    estado = models.BooleanField(default=True)
    categoria = models.ForeignKey(Categorias, on_delete=models.CASCADE)

    def __str__(self):
        return self.nombre


class Pedidos(models.Model):
    fechaPedido = models.DateField()
    usuario = models.ForeignKey(Usuarios, on_delete=models.CASCADE)

    def __str__(self):
        return f"Pedido {self.id}"


class DetallePedido(models.Model):
    pedido = models.ForeignKey(Pedidos, on_delete=models.CASCADE)
    producto = models.ForeignKey(Productos, on_delete=models.CASCADE)
    cantidad = models.IntegerField()
    subtotal = models.FloatField()

    def __str__(self):
        return f"Detalle de pedido {self.id}"


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
    pedidos = models.ForeignKey(Pedidos, on_delete=models.CASCADE)

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


class Devoluciones(models.Model):
    fechaDevolucion = models.DateTimeField(null=True)
    motivo = models.CharField(max_length=200)
    envio = models.ForeignKey(Envio, on_delete=models.CASCADE, null=True)
    productosDevueltos = models.CharField(max_length=45, null=True)
    cantidadDevuelta = models.IntegerField(null=True)
    pago = models.ForeignKey(Pago, on_delete=models.CASCADE, null=True)

    def __str__(self):
        return f"Devolución {self.id}"
