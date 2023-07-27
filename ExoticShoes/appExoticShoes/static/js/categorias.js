// ---------------------Categorias-------------------------------
let dataTable;
let dataTableIsInitialized = false;

const dataTableOptions = {
    dom: 'Bfrtip',
    buttons: ['copy', 
            'csv', 
            'excel', 
            'pdf', 
            {
                extend: 'print',
                exportOptions: {
                    columns: [0, 1] 
                }
            }],
    columnDefs: [
        { className: "centered", targets: [0, 1, 2] },
        { orderable: false, targets: [2] },
        { searchable: false, targets: [0, 2]}
    ],
    pageLength: 4,
    destroy: true
};


const initDataTable = async () => {
    if (dataTableIsInitialized) {
        dataTable.destroy();
    }

    await obtenerCat();

    dataTable = $("#tableCat").DataTable(dataTableOptions);

    dataTableIsInitialized = true;
};

var id = 0;
async function obtenerCat() {
    try {
        const response = await axios.get('/api/v1.0/categorias/');
        console.log(response);
        let data = "";
        response.data.forEach((element, index) => {
            data += `<tr>
                        <th scope="row">${index + 1}</th>
                        <td>${element.nombre}</td>
                        <td>
                            <input type="radio" name="checkOpcion" id="checkOpcion" onclick='load(${JSON.stringify(element)})'>
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
}
function agregarCat() {
    var nombre = txtNombre.value.trim();
    if (nombre === '') {
        alert('La categoria no puede estar vacío');
        return
    }

    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    axios
        .post('/api/v1.0/categorias/', {
            nombre: txtNombre.value,
        },
            {
                headers: {
                    'X-CSRFToken': csrfToken
                }
            })
        .then(function (response) {
            console.log('Categoria agregado con éxito' + response);
            obtenerCat()
            txtNombre.value = ""
        })
        .catch(function (error) {
            console.log(error)
            let mensaje = error.response.data.nombre[0]
            alert(mensaje);
            txtNombre.value = ""
        });
};
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
            console.log(response);
            obtenerCat()
            txtNombre.value = ""
        })
        .catch(function (error) {
            console.log(error);
        })
}
function eliminarCat() {
    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    let rest = confirm("Seguro de eliminar el Rol? ")
    if (rest) {
        axios.delete(`/api/v1.0/categorias/${this.id}/`, {
            headers: {
                'X-CSRFToken': csrfToken
            }
        })
            .then(function (response) {
                console.log(response);
                obtenerCat()
                txtNombre.value = ""
            })
            .catch(function (error) {
                console.log(error);
                let mensaje = error.response.data.detail
                alert(mensaje);
            })
    }
}
function limpiar() {
    document.getElementById('txtNombre').value = ""
    var radioButtons = document.getElementsByName('checkOpcion');

    radioButtons.forEach(function (radioButton) {
        radioButton.checked = false;
    });
}


window.addEventListener("load", async () => {
    await initDataTable();
});