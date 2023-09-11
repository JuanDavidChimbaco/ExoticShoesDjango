// obtener una vista previa de la imagen que esta en el input file
// function mostrar() {
//   let archivo = fileFoto.files[0, 2, 3];
//   if (archivo) {
//     let lector = new FileReader();
//     lector.onload = function (e) {
//       vistaPrevia.src = e.target.result;
//       vistaPrevia.style.display = 'block';
//     };
//     lector.readAsDataURL(archivo);
//   } else {
//     vistaPrevia.src = "";
//     vistaPrvistaPreviaevia.style.display = 'none';
//   }
// }

// trae el nombre de las categorias para mostrar en el select
async function getCategory() {
    try {
        const response = await axios.get("/api/v1.0/categorias/");
        localStorage.categoria = JSON.stringify(response.data);
        var opcion = `<option value="0">Seleccione una Categoría</option>`;
        response.data.forEach((categoria) => {
            opcion += `<option value="${categoria.id}">${categoria.nombre}</option>`;
        });
        cbCategoria.innerHTML = opcion;
    } catch (error) {
        console.error(error);
    }
}

// Variables globales
var id = 0;
let dataTable;
let dataTableIsInitialized = false;

// Opciones para el DataTable
const dataTableOptions = {
    dom: "Bfrtip",
    buttons: [
        "copy",
        "csv",
        "excel",
        "pdf",
        {
            extend: "print",
            exportOptions: {
                columns: [0, 1, 2, 3, 4, 5],
            },
        },
    ],
    columnDefs: [
        { className: "centered", targets: [0, 1, 2, 3, 4, 5, 6, 7] },
        { orderable: false, targets: [6, 7] },
        { searchable: false, targets: [0, 6, 7] },
    ],
    pageLength: 4,
    destroy: true,
    responsive: true,
};

const initDataTable = async () => {
    if (dataTableIsInitialized) {
        dataTable.destroy();
    }
    await obtenerProductos();
    dataTable = $("#tables").DataTable(dataTableOptions);
    dataTableIsInitialized = true;
};

// Obtiene los productos de la base de datos
async function obtenerProductos() {
    try {
        let data = "";
        let NombreCat = "";
        const response = await axios.get("/api/productos/");
        let categorias = JSON.parse(localStorage.categoria);
        response.data.forEach((element, index) => {
            categorias.forEach((cat) => {
                if (cat.id === element.categoria) {
                    NombreCat = cat.nombre;
                }
            });
            // Formatear el precio con separador de miles y el símbolo COP
            const precioFormateado = new Intl.NumberFormat("es-CO", {
                style: "currency",
                currency: "COP",
            }).format(element.precio);
            // const res = await axios
            data += `<tr>
                  <th scope="row">${index + 1}</th>
                  <td>${element.nombre}</td>
                  <td>${element.descripcion}</td>
                  <td>${precioFormateado}</td>
                  <td>${element.existencias}</td>
                  <td>${NombreCat}</td>
                  <td>
                    <img src="${
                        element.foto
                    }" alt="Imagen" height="100" width="100" onclick='vistaPrevia(${JSON.stringify(
                element
            )})' class="btn">
                  </td>
                  <td>
                    <input type="radio" name="checkOpcion" id="checkOpcion" onclick='load(${JSON.stringify(
                        element
                    )})'>
                  </td>
                </tr>`;
        });
        tablaPro.innerHTML = data;
    } catch (error) {
        console.error(error);
    }
}

function vistaPreviaimagen() {}

// carga los datos en el formulario para modificar o eliminar
function load(element) {
    console.log(element);
    this.id = element.id;
    txtNombre.value = element.nombre;
    txtDescripcion.value = element.descripcion;
    txtPrecio.value = element.precio;
    cbCategoria.value = element.categoria;
    vistaPreviaFoto.src = element.foto;
    vistaPreviaFoto.style.display = "block";
}

// Agregar productos a la base de datos
async function agregarPro() {
    let file = fileFoto.files[0];
    axios.defaults.xsrfCookieName = "csrftoken"; // Nombre de la cookie CSRF
    axios.defaults.xsrfHeaderName = "X-CSRFToken"; // Nombre del encabezado CSRF
    var formData = new FormData();
    formData.append("nombre", txtNombre.value);
    formData.append("descripcion", txtDescripcion.value);
    formData.append("precio", txtPrecio.value);
    formData.append("categoria", cbCategoria.value);
    formData.append("foto", file);
    try {
        const response = await axios.post("/api/productos/", formData);
        console.log(response.data);
        await imagenProducto();
        await tallaProducto();
    } catch (error) {
        swal.fire({
            icon: "error",
            title: "Oops...",
            text: error.response.data,
        });
    }
}

// Modificar productos a la base de datos
function modificarPro() {
    var csrfToken = document.getElementsByName("csrfmiddlewaretoken")[0].value;
    var fileInput = document.getElementById("fileFoto");
    var file = fileInput.files[0];

    var formData = new FormData();
    formData.append("id", this.id);
    formData.append("nombre", txtNombre.value);
    formData.append("descripcion", txtDescripcion.value);
    formData.append("precio", txtPrecio.value);
    formData.append("existencias", txtCantidad.value);
    formData.append("categoria", cbCategoria.value);
    formData.append("foto", file);

    axios
        .put(`/api/v1.0/productos/${this.id}/`, formData, {
            headers: {
                "X-CSRFToken": csrfToken,
                "Content-Type": "multipart/form-data",
            },
        })
        .then(function (response) {
            console.log(response);
            obtenerProductos();
            limpiar();
        })
        .catch(function (error) {
            console.log(error);
            if (error.response.data.foto) {
                swal.fire({
                    icon: "error",
                    title: "Oops...",
                    text: "Debe cargar una imagen",
                });
            }
        });
}

// Eliminar productos a la base de datos
function eliminarPro() {
    var csrfToken = document.getElementsByName("csrfmiddlewaretoken")[0].value;
    Swal.fire({
        title: "Desea Eliminar el Producto?",
        text: "Si lo haces no se podra Revertir!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Si, Eliminarlo!",
    }).then((result) => {
        if (result.isConfirmed) {
            Swal.fire(
                "Eliminado!",
                "Su Producto ha sido Eliminado.",
                "success"
            );
            axios
                .delete(`/api/v1.0/productos/${this.id}/`, {
                    headers: {
                        "X-CSRFToken": csrfToken,
                    },
                })
                .then(function (response) {
                    console.log(response);
                    obtenerProductos();
                    limpiar();
                })
                .catch(function (error) {
                    console.log(error);
                });
        }
    });
}

// Limpiar los campos del formulario
function limpiar() {
    id = 0;
    vistaPreviaFoto.src = "";
    txtNombre.value = "";
    txtDescripcion.value = "";
    txtPrecio.value = "";
    txtCantidad.value = "";
    cbCategoria.value = 0;
    fileFoto.value = "";
    var radioButtons = document.getElementsByName("checkOpcion");

    radioButtons.forEach(function (radioButton) {
        radioButton.checked = false;
    });
}

// Eventos para obtener los productos y traer el nombre de las categorias
window.addEventListener("load", async () => {
    await initDataTable();
    await NombreCat();
});
