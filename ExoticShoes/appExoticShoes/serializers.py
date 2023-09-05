from rest_framework import serializers
from .models import  Usuario, Categoria, Producto, Pedido, DetallePedido, Pago, Envio, Devolucione, CartItem , Cart
from django.contrib.auth.models import User

# Definir los serializadores 
class UsuariosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = '__all__'

class CategoriasSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categoria
        fields = '__all__'

class ProductosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Producto
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
        fields = ['username', 'password', 'first_name', 'last_name', 'email','telefono', 'fechaNacimiento', 'direccion']
        extra_kwargs = {'password': {'write_only': True}}

class LoginUsuarioSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField(write_only=True)  # Marcamos la contraseña como solo escritura
    def validate(self, data):
        username = data.get('username')
        password = data.get('password')
        if username and password:
            user = User.objects.filter(username=username).first()
            if user and user.check_password(password):
                # Las credenciales son válidas
                data['user'] = user
            else:
                raise serializers.ValidationError('Credenciales inválidas')
        else:
            raise serializers.ValidationError('Se requieren tanto el nombre de usuario como la contraseña')
        return data
