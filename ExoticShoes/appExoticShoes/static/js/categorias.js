// ---------------------Categorias-------------------------------
let dataTable;
let dataTableIsInitialized = false;
let id = 0;

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
                columns: [0, 1, 2],
            },
        },
    ],
    columnDefs: [
        {
            className: 'centered',
            targets: [0, 1, 2, 3],
        },
        {
            orderable: false,
            targets: [3],
        },
        {
            searchable: false,
            targets: [0, 3],
        },
    ],
    pageLength: 4,
    destroy: true,
    responsive: true,
};

const initDataTable = async () => {
    if (dataTableIsInitialized) {
        dataTable.destroy();
    }
    await obtenerCat();
    dataTable = $('#tableCat').DataTable(dataTableOptions);
    dataTableIsInitialized = true;
};

async function obtenerCat() {
    try {
        const response = await axios.get('/api/v1.0/categorias/');
        let data = '';
        response.data.forEach((element, index) => {
            data+=` <tr>
                        <th scope="row">${index + 1}</th>
                        <td class="align-middle">${element.nombre}</td>
                        <td>
                            <img src="${element.imagen}" alt="${element.nombre}" width="50" height="50" onclick='vistaImagen("${element.imagen}")'>
                        </td>
                        <td class="align-middle">
                            <input type="radio" name="checkOpcion" id="checkOpcion" onclick='load(${JSON.stringify(element)})' class="form-check-input">
                        </td>
                    </tr>`;
        });
        tabla.innerHTML = data;
    } catch (error) {}
}

async function agregarCat() {
    var file = fileFoto.files[0];
    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    var formData = new FormData();
    formData.append('nombre', txtNombre.value.trim());
    formData.append('imagen', file);
    try {
        const response = await axios.post('/api/v1.0/categorias/', formData, {
            headers: {
                'X-CSRFToken': csrfToken,
            },
        });
        Swal.fire({
            position: 'center',
            icon: 'success',
            title: 'Categoria agregada correctamente',
            showConfirmButton: true,
            allowOutsideClick: false,
            timer: 2000,
        });
        obtenerCat();
        limpiar();
    } catch (error) {
        var errorMessages = [];
        for (var key in error.response.data) {
            if (error.response.data.hasOwnProperty(key)) {
                var mensajes = error.response.data[key];
                for (var i = 0; i < mensajes.length; i++) {
                    errorMessages.push(mensajes[i]);
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
                html: errorMessageList, // Utilizamos "html" para insertar la lista como HTML
                showConfirmButton: false,
                allowOutsideClick: false,
                timer: 5000,
            });
        }
    }
}

async function modificarCat() {
    var errorMessages = [];
    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    var formData = new FormData();
    if (!fileFoto.files.length) {
        formData.append('nombre', txtNombre.value.trim());
    } else {
        let file = fileFoto.files[0];
        formData.append('nombre', txtNombre.value.trim());
        formData.append('imagen', file);
    }
    if ((this.id == undefined && txtNombre.value == '' && !fileFoto.files.length) || this.id == '') {
        Swal.fire({
            position: 'center',
            icon: 'warning',
            title: 'No ha selecionado una categoria para modificar',
            showConfirmButton: true,
            allowOutsideClick: false,
            timer: 1500,
        });
    } else {
        try {
            const response = await axios.put(`/api/v1.0/categorias/${this.id}/`, formData, {
                headers: {
                    'X-CSRFToken': csrfToken,
                },
            });
            Swal.fire({
                position: 'center',
                icon: 'success',
                title: 'Categoria Modificada correctamente',
                showConfirmButton: true,
                allowOutsideClick: false,
                timer: 1500,
            });
            obtenerCat();
            limpiar();
        } catch (error) {
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
                    html: errorMessageList, // Utilizamos "html" para insertar la lista como HTML
                    showConfirmButton: true,
                    allowOutsideClick: false,
                    timer: 5000,
                });
            }
        }
        errorMessages = [];
    }
}

async function eliminarCat() {
    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    try {
        const result = await Swal.fire({
            title: 'Eliminar ?',
            text: 'No podras Recuperar esto!',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Si, Borrar!',
        });
        if (result.isConfirmed) {
            if (this.id == '' || this.id == undefined) {
                Swal.fire({
                    position: 'center',
                    icon: 'warning',
                    title: 'No ha selecionado una categoria para eliminar',
                    showConfirmButton: true,
                    allowOutsideClick: false,
                    timer: 1500,
                });
            } else {
                try {
                    const response = await axios.delete(`/api/v1.0/categorias/${this.id}/`, {
                        headers: {
                            'X-CSRFToken': csrfToken,
                        },
                    });
                    Swal.fire('Borrado!', 'Su categoria ha sido borrada.', 'success');
                    obtenerCat();
                    limpiar();
                } catch (error) {
                    var errorMessageList = `<ul class="list-group list-group-numbered">
                                                <li class="list-group-item">${error.response.data.detail}</li>
                                            </ul>`;
                    Swal.fire({
                        position: 'center',
                        icon: 'error',
                        title: 'Oops...',
                        html: errorMessageList, // Utilizamos "html" para insertar la lista como HTML
                        showConfirmButton: true,
                        allowOutsideClick: false,
                        timer: 5000,
                    });
                }
            }
        }
    } catch (error) {}
}

function load(element) {
    this.id = element.id;
    txtNombre.value = element.nombre;
    uploadedImage.src = element.imagen;
    uploadedImage.style.display = 'block';
}

function imagen() {
    const file = fileFoto.files[0];

    if (file) {
        const reader = new FileReader();
        reader.onload = function (e) {
            uploadedImage.src = e.target.result;
            uploadedImage.style.display = 'block';
        };
        reader.readAsDataURL(file);
    } else {
        uploadedImage.src = '';
        uploadedImage.style.display = 'none';
    }
}

function vistaImagen(urlFoto) {
    Swal.fire({
        imageUrl: urlFoto,
        imageAlt: 'Custom image',
    });
}

function vistaImagenFrm() {
    url = uploadedImage.src;
    Swal.fire({
        imageUrl: url,
        imageAlt: 'Custom image',
    });
}

function limpiar() {
    this.id = '';
    txtNombre.value = '';
    fileFoto.value = '';
    uploadedImage.style.display = 'none';
    var radioButtons = document.getElementsByName('checkOpcion');
    radioButtons.forEach(function (radioButton) {
        radioButton.checked = false;
    });
}

window.addEventListener('load', async () => {
    await initDataTable();
});
