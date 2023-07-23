from django.test import TestCase, Client
from django.urls import reverse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required

class ViewsTestCase(TestCase):
    def setUp(self):
        # Crea un usuario de prueba para las pruebas de inicio de sesión
        self.user = User.objects.create_user(username='testuser', password='testpassword')

    def test_redirect_to_login(self):
        # Prueba que la vista de redirección a login tenga éxito
        response = self.client.get(reverse('redirect_to_login'))
        self.assertEqual(response.status_code, 302)  # Verifica que la redirección se realice correctamente

    def test_custom_login_exitoso(self):
        # Prueba de inicio de sesión exitoso
        response = self.client.post(reverse('login'), {'username': 'testuser', 'password': 'testpassword'})
        self.assertEqual(response.status_code, 200)  # Verifica que el inicio de sesión tenga éxito
        self.assertContains(response, '¡Login exitoso!')  # Verifica que se muestre el mensaje de éxito

    def test_custom_login_fallido(self):
        # Prueba de inicio de sesión fallido con credenciales incorrectas
        response = self.client.post(reverse('login'), {'username': 'testuser', 'password': 'incorrectpassword'})
        self.assertEqual(response.status_code, 200)  # Verifica que el inicio de sesión tenga éxito (puede redirigir a la misma página)
        self.assertContains(response, 'Usuario o contraseña incorrectos.')  # Verifica que se muestre el mensaje de error

    def test_inicio(self):
        # Prueba que la vista de inicio tenga éxito cuando el usuario ha iniciado sesión
        self.client.login(username='testuser', password='testpassword')
        response = self.client.get(reverse('inicio'))
        self.assertEqual(response.status_code, 200)  # Verifica que la vista de inicio cargue correctamente

    def test_inicio_sin_autenticacion(self):
        # Prueba que la vista de inicio redireccione al login cuando el usuario no ha iniciado sesión
        response = self.client.get(reverse('inicio'))
        self.assertEqual(response.status_code, 302)  # Verifica que se realice la redirección
        self.assertRedirects(response, reverse('login') + '?next=/inicio/')  # Verifica que se realice la redirección a la página de inicio de sesión

    def test_categorias(self):
        # Prueba que la vista de categorías tenga éxito cuando el usuario ha iniciado sesión
        self.client.login(username='testuser', password='testpassword')
        response = self.client.get(reverse('categorias'))
        self.assertEqual(response.status_code, 200)  # Verifica que la vista de categorías cargue correctamente

    def test_productos(self):
        # Prueba que la vista de productos tenga éxito cuando el usuario ha iniciado sesión
        self.client.login(username='testuser', password='testpassword')
        response = self.client.get(reverse('productos'))
        self.assertEqual(response.status_code, 200)  # Verifica que la vista de productos cargue correctamente

    def test_pedidos(self):
        # Prueba que la vista de pedidos tenga éxito cuando el usuario ha iniciado sesión
        self.client.login(username='testuser', password='testpassword')
        response = self.client.get(reverse('pedidos'))
        self.assertEqual(response.status_code, 200)  # Verifica que la vista de pedidos cargue correctamente

    def test_envios(self):
        # Prueba que la vista de envíos tenga éxito cuando el usuario ha iniciado sesión
        self.client.login(username='testuser', password='testpassword')
        response = self.client.get(reverse('envios'))
        self.assertEqual(response.status_code, 200)  # Verifica que la vista de envíos cargue correctamente

    def test_custom_logout(self):
        # Prueba que la vista de cierre de sesión redireccione al login
        self.client.login(username='testuser', password='testpassword')
        response = self.client.get(reverse('logout'))
        self.assertRedirects(response, reverse('login'))  # Verifica que se realice la redirección al login
        
        # Verifica que el usuario ya no está autenticado después del cierre de sesión
        is_authenticated = response.wsgi_request.user.is_authenticated
        self.assertFalse(is_authenticated)
