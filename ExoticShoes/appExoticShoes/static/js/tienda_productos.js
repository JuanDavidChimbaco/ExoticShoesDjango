// const prevBtn = document.getElementById('prevBtn');
// const nextBtn = document.getElementById('nextBtn');
// // const reloader = document.getElementById('reloader'); // Elemento del reloader

// let productos = []; // Aquí guarda tus productos
// let currentPage = 1; // Página actual

// async function getProducts(pageNumber) {
//     try {
//         //reloader.style.display = 'block'; // Mostrar el reloader
//         const response = await axios.get(`/api/v1.0/productosPagination/?page=${pageNumber}`);
//         console.log(response.data);
//         updateProductDisplay(response.data);
//     } catch (error) {
//         console.error(error);
//     }
//     //     } finally {
//     //         reloader.style.display = 'none'; // Ocultar el reloader una vez que se carguen los productos
//     //     }
// }

// function updateProductDisplay(data) {
//     let datos = '';
//     data.results.forEach((element) => {
//         datos += `
//                <div class="col-md-4 mb-4">
//                     <div class="card producto-card" height="300">
//                          <img src="${element.imagen}" alt="producto" class="card-img-top" width="100" height="150">
//                          <div class="card-body">
//                               <h5 class="card-title">${element.nombre}</h5>
//                               <p class="card-text">${element.descripcion}</p>
//                               <p class="card-text">Precio: $${element.precio}</p>
//                          </div>
//                          <div class="card-footer">
//                               <button type="button" class="btn btn-primary">Comprar</button>
//                          </div>
//                     </div>
//                </div>
//    `;
//     });
//     contenedorPro.innerHTML = datos;
// }

// function previousPage() {
//     console.log(currentPage);
//     if (currentPage > 1) {
//         getProducts(currentPage - 1);
//     }
// }

// function nextPage() {
//     getProducts(currentPage + 1);
// }

// // Cargar los productos de la primera página al cargar la página
// getProducts(currentPage);

document.addEventListener('DOMContentLoaded', function () {
    // Tu código JavaScript aquí
    let currentPage = 1; // Página actual
    let totalPages = 1; // Número total de páginas

    const resultsContainer = document.getElementById('resultsContainer');
    const paginationContainer = document.getElementById('paginationContainer');

    // Función para cargar datos de una página específica
    function cargarPagina(page) {
        if (page < 1 || page > totalPages) {
            return; // Evita cargar páginas fuera del rango válido
        }

        const url = `http://127.0.0.1:8000/api/v1.0/productosPagination/?page=${page}`;

        axios
            .get(url)
            .then((response) => {
                const data = response.data;
                mostrarResultadosEnHTML(data.results);
                currentPage = page; // Actualiza la página actual
                actualizarPaginacion(data.next, data.previous);
            })
            .catch((error) => {
                console.error('Error al obtener los productos:', error);
            });
    }

    // Función para mostrar resultados en HTML
    function mostrarResultadosEnHTML(resultados) {
        resultsContainer.innerHTML = ''; // Limpia el contenido anterior

        if (resultados.length === 0) {
            resultsContainer.innerHTML = '<p>No se encontraron productos.</p>';
        } else {
            resultados.forEach((producto) => {
                // Crea elementos HTML para mostrar la información del producto
                const productoDiv = document.createElement('div');
                productoDiv.classList.add('product-card'); // Agrega una clase
                productoDiv.innerHTML = `
                    <h3>${producto.nombre}</h3>
                    <p>${producto.descripcion}</p>
                    <p>Precio: $${parseFloat(producto.precio).toFixed(2)}</p>
                    <img src="${producto.imagen}" alt="${producto.nombre}" style="max-width: 100%; height: auto;"/>
                    `;
                resultsContainer.appendChild(productoDiv);
            });
        }
    }

    // Función para actualizar la paginación
    function actualizarPaginacion(nextPageUrl, prevPageUrl) {
        paginationContainer.innerHTML = ''; // Limpia la paginación existente

        const prevPage = document.createElement('li');
        prevPage.classList.add('page-item');
        const prevLink = document.createElement('a');
        prevLink.classList.add('page-link');
        prevLink.textContent = 'Previous';
        prevLink.href = '#';
        prevLink.addEventListener('click', () => {
            cargarPagina(currentPage - 1);
        });
        prevPage.appendChild(prevLink);

        const nextPage = document.createElement('li');
        nextPage.classList.add('page-item');
        const nextLink = document.createElement('a');
        nextLink.classList.add('page-link');
        nextLink.textContent = 'Next';
        nextLink.href = '#';
        nextLink.addEventListener('click', () => {
            cargarPagina(currentPage + 1);
        });
        nextPage.appendChild(nextLink);

        paginationContainer.appendChild(prevPage);

        // Verifica si hay una página anterior
        if (prevPageUrl === null) {
            prevPage.classList.add('disabled');
            prevLink.removeAttribute('href');
        }

        // Verifica si hay una página siguiente
        if (nextPageUrl === null) {
            nextPage.classList.add('disabled');
            nextLink.removeAttribute('href');
        }

        paginationContainer.appendChild(nextPage);
    }

    // Obtener el número total de páginas y cargar la primera página al cargar la página web
    axios
        .get('http://127.0.0.1:8000/api/v1.0/productosPagination/')
        .then((response) => {
            totalPages = Math.ceil(response.data.count / 6); // Supongo que estás mostrando 6 productos por página
            cargarPagina(currentPage);
        })
        .catch((error) => {
            console.error('Error al obtener metadatos de paginación:', error);
        });
});
