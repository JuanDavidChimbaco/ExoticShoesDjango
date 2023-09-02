from rest_framework import serializers
from .models import  Usuario, Categoria, Producto, Pedido, DetallePedido, Pago, Envio, Devolucione, CartItem , Cart
from django.contrib.auth.models import User
from django.contrib.auth.models import Group

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

class PedidosSerializer(serializers.ModelSerializer):
    usuario_id = serializers.PrimaryKeyRelatedField(queryset=Usuario.objects.all(), source='usuario', write_only=True)
    class Meta:
        model = Pedido
        fields = 'id', 'fechaPedido', 'usuario_id'
    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation['usuario'] = UsuariosSerializer(instance.usuario).data
        return representation
        
class DetallePedidoSerializer(serializers.ModelSerializer):
    pedido_id = serializers.PrimaryKeyRelatedField(queryset=Pedido.objects.all(), source='pedido', write_only=True)
    producto_id = serializers.PrimaryKeyRelatedField(queryset=Producto.objects.all(), source='producto', write_only=True)
    
    class Meta:
        model = DetallePedido
        fields = ['pedido_id', 'producto_id', 'cantidad', 'subtotal']
        
class PagoSerializer(serializers.ModelSerializer):
    pedidos = PedidosSerializer()
    class Meta:
        model = Pago
        fields = '__all__'

class EnvioSerializer(serializers.ModelSerializer):
    estadoPago = PagoSerializer()
    class Meta:
        model = Envio
        fields = '__all__'

class DevolucionesSerializer(serializers.ModelSerializer):
    envio = EnvioSerializer()
    pago = PagoSerializer()
    class Meta:
        model = Devolucione
        fields = '__all__'

class CartItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = CartItem
        fields = '__all__'

class CartSerializer(serializers.ModelSerializer):
    products = CartItemSerializer(many=True, read_only=True)

    class Meta:
        model = Cart
        fields = '__all__'

# Funcionalidad para el registro de usuarios (Solo para el cliente) 
class RegistroUsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = ['username', 'password', 'first_name', 'last_name', 'email','telefono', 'fechaNacimiento', 'direccion']
        # exclude = ['last_login','is_staff','is_active','date_joined', 'groups', 'is_superuser', 'user_permissions']
        extra_kwargs = {'password': {'write_only': True}}
        
    def create(self, validated_data):
        user = Usuario.objects.create_user(**validated_data)
        cliente_group = Group.objects.get(name='cliente')  # Asegúrate de que el grupo 'cliente' exista
        user.groups.add(cliente_group)
        return user
        
class LoginUsuarioSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField()
