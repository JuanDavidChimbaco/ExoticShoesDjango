const id = localStorage.getItem('productoSelecionado')

// Obtener el ID del producto desde la URL
const urlParams = new URLSearchParams(window.location.search);
const idProducto = urlParams.get('id');

if (idProducto) {
    // solicitud GET al servidor con el ID incluido en la URL
    fetch(`http://127.0.0.1:8000/api/v1.0/productosCliente/${idProducto}`)
        .then((response) => {
            if (response.ok) {
                console.log(response)
                return response.json();
            } else {
                throw new Error('No se pudo obtener el producto');
            }
        })
        .then((producto) => {
            console.log(producto)
            const detallesProductoElement = document.getElementById('detallesProducto');
            detallesProductoElement.innerHTML = `
            <div class="card text-center">
            <div class="card-body">
                <h3 class="card-title">${producto.nombre}</h3>
                <p class="card-text">Precio: $${parseFloat(producto.precio).toFixed(2)}</p>
                <img src="${producto.imagen}" alt="${producto.nombre}" class="img-fluid rounded" style="max-width: 100%; height: 400px;" />
            </div>
        </div>
            `;
        })
        .catch((error) => {
            console.error('Error al obtener los detalles del producto', error);
        });
} else {
    console.error('No se encontró el ID del producto en la URL');
}
