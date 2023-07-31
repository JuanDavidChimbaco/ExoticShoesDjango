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
    class Meta:
        model = Productos
        fields = '__all__'
        
class ItemCarritoSerializer(serializers.ModelSerializer):
    producto = ProductosSerializer()

    class Meta:
        model = ItemCarrito
        fields = '__all__'
        
    def create(self, validated_data):
        # Extract nested data if present
        nested_data = validated_data.pop('nested_field', None)

        # Create the item carrito instance
        item_carrito = ItemCarrito.objects.create(**validated_data)

        # Handle nested data if present and create related objects
        if nested_data:
            # Create or update related objects based on nested_data
            # For example:
            UsuariosSerializer.objects.create(item_carrito=item_carrito, **nested_data)

        return item_carrito

class PedidosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pedidos
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
        model = Devoluciones
        fields = '__all__'

