from django.contrib import admin
from .models import (
    # Stock,
    Usuario,
    Categoria,
    Producto,
    Talla,
    Pedido,
    DetallePedido,
    Pago,
    Envio,
    Devolucione,
    Cart,
    CartItem,
)

# Registra tus modelos aquí


@admin.register(Usuario)
class UsuarioAdmin(admin.ModelAdmin):
    list_display = (
        "username",
        "telefono",
        "fechaNacimiento",
        "direccion",
        "fotoPerfil",
    )


admin.site.register(Categoria)
admin.site.register(Producto)
admin.site.register(Talla)

admin.site.register(Pedido)



@admin.register(DetallePedido)
class DetallePedidoAdmin(admin.ModelAdmin):
    list_display = ("pedido", "producto", "cantidad", "subtotal")


admin.site.register(Pago)

admin.site.register(Envio)

@admin.register(Devolucione)
class DevolucionAdmin(admin.ModelAdmin):
    list_display = ("pedido", "motivo", "fechaDevolucion")


class CartItemAdmin(admin.TabularInline):
    model = CartItem
    extra = 1  # Define cuántos formularios vacíos para agregar


@admin.register(Cart)
class CartAdmin(admin.ModelAdmin):
    inlines = [CartItemAdmin]
