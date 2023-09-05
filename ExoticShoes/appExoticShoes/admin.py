from django.contrib import admin
from .models import Usuario, Categoria, Producto, ImagenProducto, Talla, ProductoConTalla, Pedido, DetallePedido, Pago, Envio, Devolucione, Cart, CartItem

# Registra tus modelos aquí

@admin.register(Usuario)
class UsuarioAdmin(admin.ModelAdmin):
    list_display = ('username', 'telefono', 'fechaNacimiento', 'direccion', 'fotoPerfil')
    # Personaliza la lista de campos que deseas mostrar en el panel de administración

@admin.register(Categoria)
class CategoriaAdmin(admin.ModelAdmin):
    list_display = ('nombre',)

@admin.register(Producto)
class ProductoAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'descripcion', 'precio', 'existencias', 'estado', 'categoria')

@admin.register(ImagenProducto)
class ImagenProductoAdmin(admin.ModelAdmin):
    list_display = ('producto', 'imagen')

@admin.register(Talla)
class TallaAdmin(admin.ModelAdmin):
    list_display = ('nombre',)

@admin.register(ProductoConTalla)
class ProductoConTallaAdmin(admin.ModelAdmin):
    list_display = ('producto', 'talla', 'existencias')

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