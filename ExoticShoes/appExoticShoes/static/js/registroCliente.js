function registro() {
    const fotoPerfilInput = document.getElementById('fotoPerfil');
    if (!fotoPerfilInput || !fotoPerfilInput.files[0]) {
        // Mostrar un mensaje de error si no se selecciona un archivo
        Swal.fire({
            title: 'Error',
            text: 'Selecciona una foto de perfil antes de continuar.',
            icon: 'error',
        });
        return; // Salir de la función si no hay archivo seleccionado
    }

    const fotoPerfil = fotoPerfilInput.files[0];
    const formData = new FormData();
    formData.append('username', username.value);
    formData.append('password', password.value);
    formData.append('first_name', first_name.value);
    formData.append('last_name', last_name.value);
    formData.append('email', email.value);
    formData.append('telefono', telefono.value);
    formData.append('fechaNacimiento', fechaNacimiento.value);
    formData.append('direccion', direccion.value);
    formData.append('fotoPerfil', fotoPerfil, fotoPerfil.name);

    axios.defaults.xsrfCookieName = 'csrftoken'; // Nombre de la cookie CSRF
    axios.defaults.xsrfHeaderName = 'X-CSRFToken'; // Nombre del encabezado CSRF
    axios.post('/api/v1.0/registro_cliente/', formData, {
        headers: {
            'Content-Type': 'multipart/form-data', // Asegurarse de establecer el tipo de contenido adecuado
        },
    })
        .then(res => {
            // Convertir la respuesta a un objeto JavaScript
            const responseData = res.data;

            // Crear un mensaje de éxito
            const successMessage = '¡Usuario registrado correctamente…!';

            // Mostrar un mensaje de éxito con SweetAlert
            Swal.fire({
                title: 'Registro cliente',
                text: successMessage,
                icon: 'success',
                confirmButtonColor: '#0d6efd',
            }).then(() => {
                window.location.href = "/inicio_tienda/";
            });
        })
        .catch(err => {
            // Crear un mensaje de error personalizado
            let errorMessage = 'Detalles:';

            // Verificar si hay datos en la respuesta de error
            if (err.response && err.response.data) {
                const errorData = err.response.data;

                // Recorrer las propiedades del objeto de error y agregar los mensajes de error
                for (const key in errorData) {
                    if (errorData.hasOwnProperty(key)) {
                        const errorMessages = errorData[key];
                        errorMessage += `\n${key}: ${errorMessages.join(', ')}`;
                    }
                }
            } else {
                errorMessage = 'No se pudo realizar el Registro.';
            }

            // Mostrar un mensaje de error con SweetAlert
            Swal.fire({
                title: 'Error',
                text: errorMessage,
                icon: 'error',
                confirmButtonColor: '#0d6efd',
            });
        });
}