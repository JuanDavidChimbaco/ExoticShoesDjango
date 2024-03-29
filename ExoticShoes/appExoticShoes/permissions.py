from rest_framework import permissions

class AllowOnlyGET(permissions.BasePermission):
    def has_permission(self, request, view):
        # Solo permite solicitudes GET
        return request.method == 'GET'

class AllowOnlyPOST(permissions.BasePermission):
    def has_permission(self, request, view):
        # Solo permite solicitudes POST
        return request.method == 'POST'
    
class AllowOnlyAdminGroup(permissions.BasePermission):
    def has_permission(self, request, view):
        # Verificar si el usuario está autenticado y pertenece al grupo "admin"
        return request.user.is_authenticated and request.user.groups.filter(name='admin').exists()
