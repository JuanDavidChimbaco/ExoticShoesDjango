from rest_framework import serializers
from .models import Roles, Usuarios, Categorias, Productos, Pedidos, DetallePedido, Pago, Envio, Devoluciones

class RolesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Roles
        fields = '__all__'

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
        
# Define los serializadores para los demás modelos de la misma manera