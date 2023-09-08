from django.contrib import admin
from .models import Stock, Usuario, Categoria, Producto, ImagenProducto, Talla, Pedido, DetallePedido, Pago, Envio, Devolucione, Cart, CartItem

# Registra tus modelos aquí

@admin.register(Usuario)
class UsuarioAdmin(admin.ModelAdmin):
    list_display = ('username', 'telefono', 'fechaNacimiento', 'direccion', 'fotoPerfil')


@admin.register(Categoria)
class CategoriaAdmin(admin.ModelAdmin):
    list_display = ('nombre',)


class TallaAdmin(admin.ModelAdmin):
    list_display = ('nombre',)

class ImagenProductoAdmin(admin.TabularInline):
    model = ImagenProducto

class StockInline(admin.TabularInline):
    model = Stock
    extra = 1

class ProductoAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'descripcion')
    inlines = [ImagenProductoAdmin, StockInline]  # Agregamos la inline para Stock
    filter_horizontal = ('tallas',)

admin.site.register(Talla, TallaAdmin)
admin.site.register(Producto, ProductoAdmin)


@admin.register(Pedido)
class PedidoAdmin(admin.ModelAdmin):
    list_display = ('codigoPedido', 'fechaPedido', 'usuario', 'total', 'estadoPedido')


@admin.register(DetallePedido)
class DetallePedidoAdmin(admin.ModelAdmin):
    list_display = ('pedido', 'producto', 'cantidad', 'subtotal')


@admin.register(Pago)
class PagoAdmin(admin.ModelAdmin):
    list_display = ('metodo', 'fechaPago', 'estadoPago', 'confirmado', 'pedidos')


@admin.register(Envio)
class EnvioAdmin(admin.ModelAdmin):
    list_display = ('servicioEnvio', 'DireccionEnvio', 'fechaEnvio', 'estadoPago', 'estado')


@admin.register(Devolucione)
class DevolucionAdmin(admin.ModelAdmin):
    list_display = ('pedido', 'motivo', 'fechaDevolucion')


@admin.register(Cart)
class CartAdmin(admin.ModelAdmin):
    pass  # Puedes personalizar según tus necesidades


@admin.register(CartItem)
class CartItemAdmin(admin.ModelAdmin):
    pass  # Puedes personalizar según tus necesidades