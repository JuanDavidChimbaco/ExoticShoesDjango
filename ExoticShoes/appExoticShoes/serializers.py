from rest_framework import serializers
from .models import  Usuarios, Categorias, Productos, ItemCarrito, Pedidos, DetallePedido, Pago, Envio, Devoluciones

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
    categoria = CategoriasSerializer()
    class Meta:
        model = Productos
        fields = '__all__'

class PedidosSerializer(serializers.ModelSerializer):
    usuario = UsuariosSerializer()
    class Meta:
        model = Pedidos
        fields = '__all__'
        
class DetallePedidoSerializer(serializers.ModelSerializer):
    pedido = PedidosSerializer()
    producto = ProductosSerializer()
    class Meta:
        model = DetallePedido
        fields = '__all__'
        
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

class ItemCarritoSerializer(serializers.ModelSerializer):
    producto = ProductosSerializer()

    class Meta:
        model = ItemCarrito
        fields = '__all__'
        
    def create(self, validated_data):
        nested_data = validated_data.pop('nested_field', None)
        item_carrito = ItemCarrito.objects.create(**validated_data)
        if nested_data:
            UsuariosSerializer.objects.create(item_carrito=item_carrito, **nested_data)

        return item_carrito