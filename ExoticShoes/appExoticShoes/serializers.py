from rest_framework import serializers
from .models import  Usuarios, Categorias, Productos, Pedidos, DetallePedido, Pago, Envio, Devoluciones, CartItem , Cart

# Definir los serializadores 

class UsuariosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuarios
        fields = '__all__'

class CategoriasSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categorias
        fields = '__all__'

class ProductosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Productos
        fields = '__all__'

class PedidosSerializer(serializers.ModelSerializer):
    usuario_id = serializers.PrimaryKeyRelatedField(queryset=Usuarios.objects.all(), source='usuario', write_only=True)
    class Meta:
        model = Pedidos
        fields = 'id', 'fechaPedido', 'usuario_id'
    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation['usuario'] = UsuariosSerializer(instance.usuario).data
        return representation
        
class DetallePedidoSerializer(serializers.ModelSerializer):
    pedido_id = serializers.PrimaryKeyRelatedField(queryset=Pedidos.objects.all(), source='pedido', write_only=True)
    producto_id = serializers.PrimaryKeyRelatedField(queryset=Productos.objects.all(), source='producto', write_only=True)
    
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
        model = Devoluciones
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