# from django.test import TestCase
# from rest_framework.test import APIClient
# from rest_framework import status
# from django.contrib.auth.models import User, Group
# from .models import Usuario
# from .serializers import UsuariosSerializer
# from django.core import mail 

# class UsuariosViewSetTest(TestCase):
#     def setUp(self):
#         self.client = APIClient()
#         self.usuario_data = {
#             'username': 'john_doe',
#             'password': 'testpassword',
#             'telefono': '1234567890',
#             'FechaNacimiento': '2000-01-01',
#             'direccion': '123 Main St'
#         }
#         self.usuario = Usuario.objects.create_user(**self.usuario_data)
#         self.url = '/api/v1.0/usuarios/'  

#         self.client.login(username='john_doe', password='testpassword')

#     def test_list_usuarios(self):
#         response = self.client.get(self.url)
#         self.assertEqual(response.status_code, status.HTTP_200_OK)

#     def test_create_usuario(self):
#         new_usuario_data = {
#             'username': 'new_user',
#             'password': 'new_password',
#             'telefono': '9876543210',
#             'FechaNacimiento': '1995-05-05',
#             'direccion': '456 Elm St'
#         }
#         response = self.client.post(self.url, new_usuario_data, format='json')
#         self.assertEqual(response.status_code, status.HTTP_201_CREATED)
#         self.assertEqual(Usuario.objects.count(), 2) 

#     def test_retrieve_usuario(self):
#         response = self.client.get(f'{self.url}{self.usuario.id}/')
#         self.assertEqual(response.status_code, status.HTTP_200_OK)

#     def test_update_usuario(self):
#         updated_data = {
#             'username': 'new_user2',
#             'password': 'new_password2',
#             'telefono': '9876543210',
#             'FechaNacimiento': '1990-02-15',
#             'direccion': '789 Oak St'
#         }
#         response = self.client.put(f'{self.url}{self.usuario.id}/', updated_data, format='json')
#         self.assertEqual(response.status_code, status.HTTP_200_OK)
#         self.usuario.refresh_from_db()
#         self.assertEqual(self.usuario.telefono, updated_data['telefono'])
#         self.assertEqual(str(self.usuario.FechaNacimiento), updated_data['FechaNacimiento'])
#         self.assertEqual(self.usuario.direccion, updated_data['direccion'])

#     def test_delete_usuario(self):
#         response = self.client.delete(f'{self.url}{self.usuario.id}/')
#         self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
#         self.assertEqual(Usuario.objects.count(), 0)


# class RegistroUsuarioViewTest(TestCase):
#     def setUp(self):
#         self.client = APIClient()
#         self.url = '/registro/'  # Ajusta la URL de acuerdo a tu configuración de URL

#         # Crea el grupo 'cliente' si no existe
#         self.cliente_group, created = Group.objects.get_or_create(name='cliente')

#     def test_registro_usuario_exitoso(self):
#         data = {
#             'username': 'nuevo_usuario',
#             'password': 'nueva_contraseña',
#             'telefono': '1234567890',
#             'FechaNacimiento': '2000-01-01',
#             'direccion': '123 Main St'
#         }
#         response = self.client.post(self.url, data, format='json')
#         self.assertEqual(response.status_code, status.HTTP_201_CREATED)
#         self.assertEqual(Usuario.objects.count(), 1)

#     def test_registro_usuario_invalido(self):
#         data = {
#             'username': 'nuevo_usuario',
#             'password': '',  # Contraseña vacía, lo que debería ser inválido según el modelo
#             'telefono': '1234567890',
#             'FechaNacimiento': '2000-01-01',
#             'direccion': '123 Main St'
#         }
#         response = self.client.post(self.url, data, format='json')
#         self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
#         self.assertEqual(Usuario.objects.count(), 0)  # No se debe crear un usuario inválido

# # ----------------Testeado--------------------------------
# class LoginUsuarioViewTest(TestCase):
#     def setUp(self):
#         self.client = APIClient()
#         self.url = '/cliente/login/'  # Ajusta la URL de acuerdo a tu configuración de URL
#         self.user_data = {
#             'username': 'usuario_prueba',
#             'password': 'contrasena_prueba'
#         }
#         self.user = User.objects.create_user(**self.user_data)

#     def test_inicio_sesion_exitoso(self):
#         response = self.client.post(self.url, self.user_data, format='json')
#         self.assertEqual(response.status_code, status.HTTP_200_OK)
#         self.assertIn('message', response.data)
#         self.assertEqual(response.data['message'], 'Inicio de sesión exitoso')

#     def test_credenciales_invalidas(self):
#         invalid_credentials = {
#             'username': 'usuario_prueba',
#             'password': 'contrasena_incorrecta'
#         }
#         response = self.client.post(self.url, invalid_credentials, format='json')
#         self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
#         self.assertIn('message', response.data)
#         self.assertEqual(response.data['message'], 'Credenciales inválidas')

#     def test_campos_faltantes(self):
#         incomplete_data = {
#             'username': 'usuario_prueba'
#             # Faltando el campo 'password'
#         }
#         response = self.client.post(self.url, incomplete_data, format='json')
#         self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
#         self.assertIn('password', response.data)  # Debe haber un error para el campo faltante

#     def test_usuario_no_existente(self):
#         non_existent_user = {
#             'username': 'usuario_inexistente',
#             'password': 'contrasena_prueba'
#         }
#         response = self.client.post(self.url, non_existent_user, format='json')
#         self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
#         self.assertIn('message', response.data)
#         self.assertEqual(response.data['message'], 'Credenciales inválidas')

# # ------------------------------------reset password---------
# # from django.urls import reverse
# # class RestPasswordRequestViewTest(TestCase):
# #     def test_rest_password_request_view(self):
# #         # Haz una solicitud GET a la vista
# #         response = self.client.get(reverse('validarCorreo'))  # Ajusta el nombre de la URL según tu configuración
# #         # Verifica que la respuesta tenga un código de estado 200 (OK)
# #         self.assertEqual(response.status_code, 200)
# #         # Verifica que la plantilla correcta se está utilizando
# #         self.assertTemplateUsed(response, "registration/restablecer_password.html")


# class PasswordResetRequestViewTest(TestCase):
#     def setUp(self):
#         self.client = APIClient()
#         self.url = '/resetPassword/' 
#         self.user_data = {
#             'email': 'usuario_prueba@example.com'
#         }
#         self.user = User.objects.create_user(username='usuario_prueba', email='usuario_prueba@example.com')

#     def test_reset_password_request(self):
#         response = self.client.post(self.url, self.user_data, format='json')
#         self.assertEqual(response.status_code, status.HTTP_200_OK)

#         # Verifica que se haya capturado un correo electrónico
#         self.assertEqual(len(mail.outbox), 1)

#         # Verifica el contenido del correo electrónico
#         email = mail.outbox[0]
#         self.assertEqual(email.subject, 'Restablecimiento de contraseña')
#         self.assertEqual(email.to, ['usuario_prueba@example.com'])
#         self.assertIn('Se ha enviado un enlace de restablecimiento a su correo electrónico.', email.body)


# from rest_framework.test import APITestCase
# from rest_framework import status
# from django.urls import reverse
# from django.contrib.auth.models import User

# class UsuariosViewSetTestCase(APITestCase):

#     def setUp(self):
#         # Crear un usuario de prueba para autenticación
#         self.user = User.objects.create_user(username='testuser', password='testpassword')
#         self.client.login(username='testuser', password='testpassword')

#     def test_list_usuarios(self):
#         # Crear algunos usuarios de prueba
#         user1 = User.objects.create(username='user1')
#         user2 = User.objects.create(username='user2')

#         # Realizar una solicitud GET a la vista de lista de usuarios
#         url = reverse('usuarios-list')  # Asegúrate de que 'usuarios-list' sea la URL correcta de tu vista
#         response = self.client.get(url)

#         # Verificar que la solicitud sea exitosa (código de estado 200)
#         self.assertEqual(response.status_code, status.HTTP_200_OK)

#         # Imprimir la respuesta para depurar
#         print(response.content)

#         # Verificar que los usuarios se encuentren en la respuesta
#         self.assertIn(user1.username.encode(), response.content)
#         self.assertIn(user2.username.encode(), response.content)

#     def test_create_usuario(self):
#         # Datos de prueba para crear un usuario
#         data = {
#             'username': 'newuser',
#             'password': 'newpassword',
#             # Agrega otros campos necesarios para crear un usuario
#         }

#         # Realizar una solicitud POST para crear un usuario
#         url = reverse('usuarios-list')  # Asegúrate de que 'usuarios-list' sea la URL correcta de tu vista
#         response = self.client.post(url, data, format='json')

#         # Verificar que el usuario se haya creado exitosamente (código de estado 201)
#         self.assertEqual(response.status_code, status.HTTP_201_CREATED)

#         # Verificar que el usuario exista en la base de datos
#         self.assertTrue(User.objects.filter(username='newuser').exists())