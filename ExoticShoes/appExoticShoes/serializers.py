from rest_framework import serializers
from .models import (
    Stock,
    Usuario,
    Categoria,
    Producto,
    Pedido,
    DetallePedido,
    Pago,
    Envio,
    Devolucione,
    CartItem,
    Cart,
    Talla,
)
from django.contrib.auth.models import User


# Definir los serializadores
# -------------------- usuarios --------------------------
class UsuariosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = "__all__"


# ----------------------- categorias --------------------
class CategoriasSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categoria
        fields = "__all__"


# ---------------------- productos ------------------------
class TallaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Talla
        fields = "__all__"

class StockSerializer(serializers.ModelSerializer):
    class Meta:
        model = Stock
        fields = "__all__"

class ProductoSerializer(serializers.ModelSerializer):
    tallas = TallaSerializer(many=True, read_only=True)
    stock = StockSerializer(many=True, read_only=True, source="stock_set")

    class Meta:
        model = Producto
        fields = "__all__"


# ------------------- pedidos ---------------------------
class PedidoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pedido
        fields = "__all__"


class DetallePedidoSerializer(serializers.ModelSerializer):
    class Meta:
        model = DetallePedido
        fields = "__all__"


#  ----------------- pagos ----------------------------
class PagoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pago
        fields = "__all__"


# ----------------- envios -------------------------------
class EnvioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Envio
        fields = "__all__"


# ------------------------ devoluciones --------------------
class DevolucionesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Devolucione
        fields = "__all__"


# --------------------- carrito -------------------------
class CartItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = CartItem
        fields = "__all__"


class CartSerializer(serializers.ModelSerializer):
    items = CartItemSerializer(many=True, read_only=True)

    class Meta:
        model = Cart
        fields = "__all__"


# Serializer para el registro de usuarios (Solo para el cliente)
class RegistroUsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = [
            "username",
            "password",
            "first_name",
            "last_name",
            "email",
            "telefono",
            "fechaNacimiento",
            "direccion",
            "fotoPerfil",
        ]
        extra_kwargs = {"password": {"write_only": True}}


# Serializer para el login de usuarios (solo para el cliente)
class LoginUsuarioSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField(
        write_only=True
    )  # Marcar la contraseña como solo escritura
