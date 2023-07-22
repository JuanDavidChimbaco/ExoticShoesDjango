# ExoticShoesDjango
Es una tienda de ropa o de lo que se quiera usar.(categorias,productos,usuarios,pedidos y envio (aun esta es desarrollo)). 
para ejecutar la tienda primero descargan el proyecto: 

https://github.com/JuanDavidChimbaco/ExoticShoesDjango.git 

despues crea un entorno virtual con python (puedes hacerlo desde el terminal)

cd ExoticShoesDjango 
python -m venv entorno 

una vez creado lo activan 
entorno\Scripts\activate.bat

instalan las librerias requeridas 
cd ExoticShoesDjango\ExoticShoes
pip install -r requirements.txt 

una vez instalada ejecutan las migraciones 
cd ExoticShoesDjango\ExoticShoes
python manage.py makemigrations
python manage.py migrate 

crean un super user para poder ingresar (por el momento, luego les crearemos un usuario para que entren)
python manage.py createsuperuser

escriben su user
su correo 
y una contraseña (en caso de que ingresen una contraseña simple confirmenla con y/n dependeiendo de lo que quieran)

listo 
ahora solo ejecuten el servidor 
python manage.py runserver 

escriben la direccion generada en el navegador y listo: http://127.0.0.1:8000/

Nota: si desean tambien viene con una api: 
solo agregan al la direccion http://127.0.0.1:8000/api/v1.0/ 

