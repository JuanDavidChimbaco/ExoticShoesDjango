window.addEventListener('load', function () {
    var loaderWrapper = document.querySelector('.loader-wrapper');
    loaderWrapper.style.display = 'none';
});

window.onscroll = function () {
    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
        var scrollToTop = document.querySelector('.scroll-to-top');
        if (scrollToTop) {
            scrollToTop.style.display = 'block';
        }
    } else {
        var scrollToTop = document.querySelector('.scroll-to-top');
        if (scrollToTop) {
            scrollToTop.style.display = 'none';
        }
    }
};

document.addEventListener('DOMContentLoaded', function () {
    var scrollToTop = document.querySelector('.scroll-to-top');
    if (scrollToTop) {
        scrollToTop.addEventListener('click', function () {
            document.body.scrollTop = 0; // Para navegadores antiguos
            document.documentElement.scrollTop = 0; // Para navegadores modernos
        });
    }
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

async function get_categories() {
    let data = '';
    let data2 = '';
    try {
        const response = await axios.get('/api/v1.0/categorias2');
        response.data.forEach((category) => {
            data += `
                   <a class="categoriaitem" data-bs-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample" onclick="ProductsByCategory(${category.id})">
                        <img src="${category.imagen}" alt="categoria" class="rounded-circle border border-opacity-25 border-secondary" width="100" height="100">
                        <p class="fw-bold">${category.nombre}</p>
                   </a>
              `;
        });
        contenedorCategorias.innerHTML = data;
    } catch (error) {
        console.error(error);
    }
    try {
        const response = await axios.get('/api/v1.0/categorias2');
        response.data.forEach((category) => {
            data2 += `
                    <li><a class="dropdown-item" href="#">${category.nombre}</a></li>
              `;
        });
        listaCategorias.innerHTML = data2;
    } catch (error) {
        console.error(error);
    }
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
                var miModal = document.getElementById('exampleModal');
                this.username = '';
                this.password = '';
                this.rememberme = false;
                $(miModal).modal('hide');
                location.reload();
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

async function ProductsByCategory(idCategoria) {
    let productByCategory = document.getElementById('productosPorCategoria');
    let data = '';
    try {
        const response = await axios.get(`/productos/categoria/${idCategoria}/`);
        console.log(response.data);
        response.data.forEach((product) => {
            data += `
                <div class="card producto-card" height="300">
                    <img src="${product.imagen}" alt="producto" class="card-img-top" width="100" height="150">
                    <div class="card-body">
                        <h5 class="card-title">${product.nombre}</h5>
                        <p class="card-text">${product.descripcion}</p>
                        <p class="card-text">Precio: $${product.precio}</p>
                    </div>
                    <div class="card-footer">
                        <button type="button" class="btn btn-primary">Comprar</button>
                    </div>
                </div>
        `;
        });
        productByCategory.innerHTML = data;
    } catch (error) {}
}

//cargar las categorias apenas cargue el DOOM
get_categories();
