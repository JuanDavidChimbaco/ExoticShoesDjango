// Variales Globales
let id = 0;
let dataTable;
let dataTableIsInitialized = false;

const dataTableOptions = {
    dom: 'Bfrtip',
    buttons: [
        'copy',
        'csv',
        'excel',
        'pdf',
        {
            extend: 'print',
            exportOptions: {
                stripHtml: false,
                columns: [0, 1, 2, 3],
            },
        },
    ],
    columDefs: [
        {className: 'centered', targets: [0, 1, 2, 3, 4]},
        {orderable: false, targets: [4]},
        {searchable: false, targets: [0, 4]},
    ],
    pageLength: 4,
    destroy: true,
    responsive: true,
    info: false, // Desactiva la información de entradas
};

async function initDataTable() {
    if (dataTableIsInitialized) {
        dataTable.destroy();
    }
    await getSizes();
    dataTable = $('#tableTalla').DataTable(dataTableOptions);
    dataTableIsInitialized = true;
}

async function getProducts() {
    try {
        const response = await axios.get('/api/v1.0/productos/');
        console.log(response);
        localStorage.productos = JSON.stringify(response.data);
        let opcion = `<option value="0">Seleccione una producto</option>`;
        response.data.forEach((element) => {
            opcion += `<option value="${element.id}">${element.nombre}</option>`;
        });
        cbProducto.innerHTML = opcion;
    } catch (error) {
        console.error(error);
    }
}

async function getSizes() {
    try {
        const response = await axios.get('/api/v1.0/tallas/');
        let products = JSON.parse(localStorage.getItem('productos'));
        console.log(products);
        let nameProduct = '';
        let data = '';
        response.data.forEach((talla, index) => {
            products.forEach((product) => {
                if (product.id === talla.producto) {
                    nameProduct = product.nombre;
                }
            });
            data += `<tr>
                    <th scope="row">${index + 1}</th>
                    <td>${talla.talla}</td>
                    <td>${talla.cantidad}</td>
                    <td>${nameProduct}</td>
                    <td class="align-middle text-center">
                        <input type="radio" name="checkOpcion" onclick='getSizesById(${JSON.stringify(talla)})' class="form-check-input" title="Seleccionar">
                    </td>
                </tr>`;
        });
        tableContent.innerHTML = data;
    } catch (error) {
        console.error(error);
        showError(error);
    }
}

async function addSizes() {
    var errorMessages = [];
    axios.defaults.xsrfCookieName = 'csrftoken';
    axios.defaults.xsrfHeaderName = 'X-CSRFToken';
    var formData = new FormData();
    formData.append('talla', txtTalla.value.trim().toUpperCase());
    formData.append('cantidad', txtCantidad.value);
    formData.append('producto', cbProducto.value);
    if (emptyFields()) {
        Swal.fire({
            position: 'center',
            icon: 'warning',
            title: 'Hay campos vacios',
            showConfirmButton: true,
            allowOutsideClick: false,
            timer: 1500,
        });
    } else {
        try {
            const response = await axios.post('/api/v1.0/tallas/', formData);
            Swal.fire({
                position: 'center',
                icon: 'success',
                title: 'Talla agregada correctamente',
                showConfirmButton: true,
                allowOutsideClick: false,
                timer: 2000,
            });
            clean();
            await getSizes();
        } catch (error) {
            console.error(error);
            showError(error);
        }
    }
}

async function editSizes() {
    var errorMessages = [];
    axios.defaults.xsrfCookieName = 'csrftoken';
    axios.defaults.xsrfHeaderName = 'X-CSRFToken';
    var formularioData = new FormData();
    formularioData.append('talla', txtTalla.value.trim().toUpperCase());
    formularioData.append('cantidad', txtCantidad.value);
    formularioData.append('producto', cbProducto.value);
    if (emptyFields()) {
        Swal.fire({
            position: 'center',
            icon: 'warning',
            title: 'Hay campos vacios',
            showConfirmButton: true,
            allowOutsideClick: false,
            timer: 1500,
        });
    } else {
        try {
            const response = await axios.put(`/api/v1.0/tallas/${this.id}/`, formularioData);
            Swal.fire({
                position: 'center',
                icon: 'success',
                title: 'Producto Modificado correctamente',
                showConfirmButton: true,
                allowOutsideClick: false,
                timer: 2000,
            });
            clean();
            await getSizes();
        } catch (error) {
            showError(error);
        }
    }
}

async function deleteSizes() {
    var errorMessages = [];
    axios.defaults.xsrfCookieName = 'csrftoken'; // Nombre de la cookie CSRF
    axios.defaults.xsrfHeaderName = 'X-CSRFToken'; // Nombre del encabezado CSRF
    const res = await Swal.fire({
        title: 'Desea Eliminar el Producto?',
        text: 'Si lo haces no se podra Revertir!',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Si, Eliminarlo!',
    });
    if (res.isConfirmed) {
        if (this.id === '' || this.id === undefined || this.id === 0) {
            Swal.fire({
                position: 'center',
                icon: 'warning',
                title: 'No ha selecionado una talla para eliminar',
                showConfirmButton: true,
                allowOutsideClick: false,
                timer: 1500,
            });
        } else {
            try {
                const response = await axios.delete(`/api/v1.0/tallas/${this.id}/`);
                Swal.fire('Borrado!', 'Su talla ha sido borrada.', 'success');
                clean();
                await getSizes();
            } catch (error) {
                showError(JSON.stringify(error));
            }
        }
    }
}

function showError(error) {
    console.log(error);
    for (var key in error.response.data) {
        if (error.response.data.hasOwnProperty(key)) {
            var mensajes = error.response.data[key];
            if (typeof mensajes === 'string') {
                errorMessages.push(mensajes);
            } else if (mensajes instanceof Array) {
                for (var i = 0; i < mensajes.length; i++) {
                    errorMessages.push(mensajes[i]);
                }
            }
        }
    }
    if (errorMessages.length > 0) {
        var errorMessageList = '<ul class="list-group list-group-numbered">';
        for (var j = 0; j < errorMessages.length; j++) {
            errorMessageList += '<li class="list-group-item">' + errorMessages[j] + '</li>';
        }
        errorMessageList += '</ul>';
        Swal.fire({
            position: 'center',
            icon: 'error',
            title: 'Oops...',
            html: errorMessageList,
            showConfirmButton: true,
            allowOutsideClick: false,
            timer: 5000,
        });
    }
    errorMessages = [];
}

function getSizesById(element) {
    this.id = element.id;
    console.log(element);
    txtTalla.value = element.talla;
    txtCantidad.value = element.cantidad;
    cbProducto.value = element.producto;
}

function emptyFields() {
    if (txtTalla.value === '' || txtCantidad.value === '' || cbProducto.value === 0) {
        return true;
    } else {
        return false;
    }
}

function clean() {
    this.id = '';
    txtTalla.value = '';
    txtCantidad.value = '';
    cbProducto.value = 0;
    var radioButtons = document.getElementsByName('checkOpcion');
    radioButtons.forEach(function (radioButton) {
        radioButton.checked = false;
    });
}

window.addEventListener('load', async () => {
    await initDataTable();
    await getProducts();
});
