from rest_framework import permissions

class AllowOnlyGET(permissions.BasePermission):
    def has_permission(self, request, view):
        # Solo permite solicitudes GET
        return request.method == 'GET'

class AllowOnlyPOST(permissions.BasePermission):
    def has_permission(self, request, view):
        # Solo permite solicitudes POST
        return request.method == 'POST'
    
class AllowOnlyPOSTAndUnauthenticated(permissions.BasePermission):
    def has_permission(self, request, view):
        if request.method == 'POST':
            return True
        return not request.user.is_authenticated