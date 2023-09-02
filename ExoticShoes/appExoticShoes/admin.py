from django.contrib import admin
from .models import  Usuario, Categoria, Producto, Pedido, DetallePedido, Pago, Envio, Devolucione

@admin.register(Usuario)
class UsuariosAdmin(admin.ModelAdmin):
    list_display = ('username', 'telefono', 'fechaNacimiento', 'direccion')

@admin.register(Categoria)
class CategoriasAdmin(admin.ModelAdmin):
    list_display = ('nombre',)

@admin.register(Producto)
class ProductosAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'descripcion', 'precio', 'existencias', 'categoria')

@admin.register(Pedido)
class PedidosAdmin(admin.ModelAdmin):
    list_display = ('fechaPedido', 'usuario')

@admin.register(DetallePedido)
class DetallePedidoAdmin(admin.ModelAdmin):
    list_display = ('pedido', 'producto', 'cantidad', 'subtotal')

@admin.register(Pago)
class PagoAdmin(admin.ModelAdmin):
    list_display = ('metodo', 'monto', 'fecha', 'estado', 'pedidos')

@admin.register(Envio)
class EnvioAdmin(admin.ModelAdmin):
    list_display = ('servicioEnvio', 'DireccionEnv', 'fechaEnvio', 'fechaEntrega', 'estadoPago', 'estado')

@admin.register(Devolucione)
class DevolucionesAdmin(admin.ModelAdmin):
    list_display = ('fechaDevolucion', 'motivo', 'envio', 'productosDevueltos', 'cantidadDevuelta', 'pago')
