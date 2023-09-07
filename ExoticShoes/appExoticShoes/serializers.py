from rest_framework import serializers
from .models import  Usuario, Categoria, Producto, Pedido, DetallePedido, Pago, Envio, Devolucione, CartItem , Cart , ImagenProducto, Talla, ProductoConTalla
from django.contrib.auth.models import User

# Definir los serializadores 
class UsuariosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = ''

class CategoriasSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categoria
        fields = '__all__'

class ProductoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Producto
        fields = '__all__'
        
class ImagenProductoSerializer(serializers.ModelSerializer):
    class Meta:
        model = ImagenProducto
        fields = '__all__'

class TallaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Talla
        fields = '__all__'

class ProductoConTallaSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductoConTalla
        fields = '__all__'

class PedidoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pedido
        fields = '__all__'
        
class DetallePedidoSerializer(serializers.ModelSerializer):
    class Meta:
        model = DetallePedido
        fields = '__all__'
  
class PagoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pago
        fields = '__all__'

class EnvioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Envio
        fields = '__all__'

class DevolucionesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Devolucione
        fields = '__all__'

class CartItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = CartItem
        fields = '__all__'

class CartSerializer(serializers.ModelSerializer):
    items = CartItemSerializer(many=True, read_only=True)
    class Meta:
        model = Cart
        fields = '__all__'

# Funcionalidad para el registro de usuarios (Solo para el cliente) 
class RegistroUsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = ['username', 'password', 'first_name', 'last_name', 'email', 'telefono', 'fechaNacimiento', 'direccion', 'fotoPerfil']
        extra_kwargs = {'password': {'write_only': True}}
        

class LoginUsuarioSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField(write_only=True)  # Marcamos la contraseña como solo escritura

