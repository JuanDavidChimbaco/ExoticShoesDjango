from django.contrib import admin
from .models import  Usuarios, Categorias, Productos, Pedidos, DetallePedido, Pago, Envio, Devoluciones

@admin.register(Usuarios)
class UsuariosAdmin(admin.ModelAdmin):
    list_display = ('telefono','FechaNacimiento','direccion')

@admin.register(Categorias)
class CategoriasAdmin(admin.ModelAdmin):
    list_display = ('nombre',)

@admin.register(Productos)
class ProductosAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'descripcion', 'precio', 'cantidadEnInventario', 'categoria')

@admin.register(Pedidos)
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

@admin.register(Devoluciones)
class DevolucionesAdmin(admin.ModelAdmin):
    list_display = ('fechaDevolucion', 'motivo', 'envio', 'productosDevueltos', 'cantidadDevuelta', 'pago')
