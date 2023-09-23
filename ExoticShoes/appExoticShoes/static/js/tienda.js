window.addEventListener('load', function () {
    var loaderWrapper = document.querySelector('.loader-wrapper');
    loaderWrapper.style.display = 'none';
});

function search() {
    fetch()
        .then((response) => response.json())
        .then((data) => {
            let buscar = document.getElementById('search').value;
            if (buscar.length >= 2) {
                document.getElementById('list-producto').classList.remove('hide');
                let List = '<div class="List-group">';
                const filtroproducto = data.results.filter(filtrarproducto);
                filtroproducto.forEach((producto) => {
                    iconoproducto(producto.url);
                    list += `<a onlcick="detalleproducto(${'producto.url'})" href="/nav.html" class="list-group-item list-group-item-action"> <img id="icono${pokemon.name}"> ${
                        producto.name
                    }</a>`;
                });
                list += '</div>';
                document.getElementById('List-product').innerHTML = list;
            } else {
                document.getElementById('list-producto').innerHTML = '';
                document.getElementById('list-producto').classList.add('hide');
            }
        });
}

function filtrarproducto(element) {
    let buscar = document.getElementById('search').value;
    let name = element.name;
    return name.includes(buscar.toLowerCase());
}

function viewLogin() {
    let login = document.getElementById('login');
    login.style.display = block;
}

async function login() {
    const formData = {
        username: id_username.value,
        password: id_password.value,
        rememberme: remember_me.value,
    };
    axios.defaults.xsrfCookieName = 'csrftoken'; // Nombre de la cookie CSRF
    axios.defaults.xsrfHeaderName = 'X-CSRFToken'; // Nombre del encabezado CSRF;
    try {
        const response = await axios.post('/api/v1.0/sesion_cliente/', formData);
        console.log(response);
        Swal.fire({
            position: 'center',
            icon: 'success',
            iconColor: '#2ECC71',
            title: '¡Genial! ' + response.data.message,
            showConfirmButton: true,
            confirmButtonColor: '#17202A',
            allowOutsideClick: false,
        }).then(() => {
            if (response.data.user.groups[0] === 2) {
                console.log('logueado como cliente');
                var miModal = document.getElementById('exampleModal');
                let logeado = document.getElementById('logueado');
                let noLogeado = document.getElementById('sinLoguear');
                this.username = '';
                this.password = '';
                this.rememberme = false;
                $(miModal).modal('hide');
                noLogeado.style.display = none;
                logeado.style.display = block;
            }
            if (response.data.user.groups[0] === 1) {
                window.location.href = '/dashboard/';
            }
        });
    } catch (error) {
        console.error(error.response.data);
        Swal.fire({
            position: 'center',
            icon: 'error',
            title: 'Oops... ' + error.response.data.message,
            showConfirmButton: false,
            allowOutsideClick: false,
            timer: 2000,
        }).then(() => {
            id_username.value = '';
            id_password.value = '';
            remember_me.value = false;
        });
    }
}
