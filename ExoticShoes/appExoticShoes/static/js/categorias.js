// ---------------------Categorias-------------------------------
let dataTable;
let dataTableIsInitialized = false;
var id = 0;


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
    })
}

function vistaImagenFrm() {
    url = uploadedImage.src
    Swal.fire({
        imageUrl: url,
        imageAlt: 'Custom image',
    })
}

const dataTableOptions = {
    dom: 'Bfrtip',
    buttons: ['copy',
        'csv',
        'excel',
        'pdf',
        {
            extend: 'print',
            exportOptions: {
                stripHtml : false,
                columns: [0, 1, 2]
            }
        }],
    columnDefs: [
        { className: "centered", targets: [0, 1, 2] },
        { orderable: false, targets: [2] },
        { searchable: false, targets: [0, 2] }
    ],
    pageLength: 4,
    destroy: true,
    responsive: true
}

const initDataTable = async () => {
    if (dataTableIsInitialized) {
        dataTable.destroy();
    }

    await obtenerCat();

    dataTable = $("#tableCat").DataTable(dataTableOptions);

    dataTableIsInitialized = true;
}

async function obtenerCat() {
    try {
        const response = await axios.get('/api/v1.0/categorias/');
        console.log(response);
        let data = "";
        response.data.forEach((element, index) => {
            data += `<tr>
                        <th scope="row">${index + 1}</th>
                        <td class="align-middle">${element.nombre}</td>
                        <td><img src="${element.imagenCategoria}" alt="${element.nombre}" width="50" height="50" onclick='vistaImagen("${element.imagenCategoria}")'></td>
                        <td class="align-middle">
                            <input type="radio" name="checkOpcion" id="checkOpcion" onclick='load(${JSON.stringify(element)})' class="form-check-input">
                        </td>
                    </tr>`;
        });
        tabla.innerHTML = data;
    } catch (error) {
        console.error(error);
    }
}

function load(element) {
    console.log(element);
    this.id = element.id;
    txtNombre.value = element.nombre;
    uploadedImage.src = element.imagenCategoria;
    uploadedImage.style.display = 'block';
}

function agregarCat() {
    var fileInput = document.getElementById("fileFoto");
    var file = fileInput.files[0];
    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;

    var formData = new FormData();
    formData.append("nombre", txtNombre.value.trim());
    formData.append("imagenCategoria", file);

    axios
        .post('/api/v1.0/categorias/', formData,
            {
                headers: {
                    'X-CSRFToken': csrfToken
                }
            })
        .then(function (response) {
            Swal.fire({
                position: 'center',
                icon: 'success',
                title: 'Categoria agregada correctamente',
                showConfirmButton: true,
                allowOutsideClick: false,
                timer: 2000
            });
            obtenerCat()
            limpiar()
        })
        .catch(function (error) {
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
                    timer: 5000
                });
            }
        });
}

function modificarCat() {
    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    console.log(this.id);
    axios.put(`/api/v1.0/categorias/${this.id}/`, {
        id: this.id,
        nombre: txtNombre.value,
    },
        {
            headers: {
                'X-CSRFToken': csrfToken
            }
        })
        .then(function (response) {
            Swal.fire({
                position: 'center',
                icon: 'success',
                title: 'Categoria Modificada correctamente',
                showConfirmButton: true,
                allowOutsideClick: false,
                timer: 2000
            });
            obtenerCat()
            limpiar()
        })
        .catch(function (error) {
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
                    timer: 5000
                });
            }
        })
}

function eliminarCat() {
    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    Swal.fire({
        title: 'Eliminar ?',
        text: "No podras Recuperar esto!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Si, Borrar!'
    }).then((result) => {
        if (result.isConfirmed) {
            axios.delete(`/api/v1.0/categorias/${this.id}/`, {
                headers: {
                    'X-CSRFToken': csrfToken
                }
            })
                .then(function (response) {
                    console.log(response);
                    Swal.fire(
                        'Borrado!',
                        'Su categoria ha sido borrada.',
                        'success'
                    )
                    obtenerCat()
                    limpiar()
                })
                .catch(function (error) {
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
                            timer: 5000
                        });
                    }
                });
        }
    })
}

function limpiar() {
    txtNombre.value = ""
    fileFoto.value = ""
    uploadedImage.style.display = 'none'
    var radioButtons = document.getElementsByName('checkOpcion');

    radioButtons.forEach(function (radioButton) {
        radioButton.checked = false;
    });
}

window.addEventListener("load", async () => {
    await initDataTable();
});