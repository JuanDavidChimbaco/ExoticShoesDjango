from django.test import TestCase, Client
from django.urls import reverse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required

class ViewsTestCase(TestCase):
    def test_redirect_to_login(self):
        response = self.client.get(reverse('redirect_to_login'))
        self.assertEqual(response.status_code, 302)  # Debería redirigir a la página de inicio (código 302)

    def test_index(self):
        response = self.client.get(reverse('login'))
        self.assertEqual(response.status_code, 200)  # Debería devolver un código de respuesta 200 (éxito)

    def test_restPasswordRequest(self):
        response = self.client.get(reverse('validarCorreo'))
        self.assertEqual(response.status_code, 200)  # Debería devolver un código de respuesta 200 (éxito)

    def test_mensajeCorreo(self):
        response = self.client.get(reverse('mensajeCorreo'))
        self.assertEqual(response.status_code, 200)  # Debería devolver un código de respuesta 200 (éxito)

    # def test_restPassword(self):
    #     token = "your_token_here"  # Sustituye con un token válido
    #     response = self.client.get(reverse('restPassword') + f'?token={token}')
    #     self.assertEqual(response.status_code, 200)  # Debería devolver un código de respuesta 200 (éxito)
    
    
    def setUp(self):
        # Usuario de prueba para las pruebas de inicio de sesión
        # Usuario administrador
        self.admin_user = User.objects.create_user(
            username='admin',
            password='admin_password',
            is_staff=True,
            is_superuser=True
        )
        # Usuario que no es administrador
        self.non_admin_user = User.objects.create_user(
            username='user',
            password='user_password'
        )

    def test_dashboard_admin(self):
        self.client.login(username='admin', password='admin_password')
        response = self.client.get(reverse('dashboard'))
        self.assertEqual(response.status_code, 200)  
        self.client.logout()  
        
    def test_dashboard_non_admin(self):
        self.client.login(username='user', password='user_password')
        response = self.client.get(reverse('dashboard'))
        self.assertEqual(response.status_code, 403) 


    def test_categorias(self):
        self.client.login(username='admin', password='admin_password')
        response = self.client.get(reverse('categorias'))
        self.assertEqual(response.status_code, 200)  

    def test_productos(self):
        self.client.login(username='admin', password='admin_password')
        response = self.client.get(reverse('productos'))
        self.assertEqual(response.status_code, 200)
        
    def test_tallas(self):
        self.client.login(username='admin', password='admin_password')
        response = self.client.get(reverse('tallas'))
        self.assertEqual(response.status_code, 200) 

    def test_pedidos(self):
        self.client.login(username='admin', password='admin_password')
        response = self.client.get(reverse('pedidos'))
        self.assertEqual(response.status_code, 200) 
        
    def test_envios(self):
        self.client.login(username='admin', password='admin_password')
        response = self.client.get(reverse('envios'))
        self.assertEqual(response.status_code, 200)  

    def test_custom_logout(self):
        self.client.login(username='user', password='user_password')
        response = self.client.get(reverse('custom_logout'))
        self.assertEqual(response.status_code, 302)   
        
  
        is_authenticated = response.wsgi_request.user.is_authenticated
        self.assertFalse(is_authenticated)

class ClientViewsTestCase(TestCase):
    def setUp(self):
        # Usuario cliente
        self.client_user = User.objects.create_user(
            username='cliente',
            password='cliente_password',
            is_staff=False
        )

    def test_inicioCliente_client(self):
        self.client.login(username='cliente', password='cliente_password')
        response = self.client.get(reverse('inicio_cliente'))
        self.assertEqual(response.status_code, 200) 
        self.client.logout() 

    def test_loginCliente_client(self):
        response = self.client.get(reverse('login_cliente'))
        self.assertEqual(response.status_code, 200)
        
    def test_registroCliente_client(self):
        response = self.client.get(reverse('registro_cliente'))
        self.assertEqual(response.status_code, 200) 
        
    def test_cerrar_sesion(self):
        self.client.login(username='user', password='user_password')
        response = self.client.get(reverse('custom_logout'))
        self.assertEqual(response.status_code, 302)  