// obtener una vista previa de la imagen que esta en el input file
function mostrarVistaPrevia() {
  var fileInput = document.getElementById("fileFoto");
  var imagenMostrar = document.getElementById("vistaPreviaFoto");

  var archivo = fileInput.files[0];
  var lector = new FileReader();

  lector.onload = function (e) {
    imagenMostrar.src = e.target.result;
  };

  if (archivo) {
    lector.readAsDataURL(archivo);
  }
}

// trae el nombre de las categorias para mostrar en el select
async function NombreCat() {
  try {
    const response = await axios.get("/api/v1.0/categorias/");
    localStorage.categoria = JSON.stringify(response.data);
    var opcion = `<option value="0">Seleccione Categoría</option>`;
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
  dom: 'Bfrtip',
  buttons: ['copy', 'csv', 'excel', 'pdf',
    {
      extend: 'print',
      exportOptions: {
        columns: [0, 1, 2, 3, 4, 5]
      }
    }],
  columnDefs: [
    { className: "centered", targets: [0, 1, 2, 3, 4, 5, 6, 7] },
    { orderable: false, targets: [6, 7] },
    { searchable: false, targets: [0, 6, 7] }
  ],
  pageLength: 4,
  destroy: true,
  responsive: true
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

      data += `<tr>
                  <th scope="row">${index + 1}</th>
                  <td>${element.nombre}</td>
                  <td>${element.descripcion}</td>
                  <td>${precioFormateado}</td>
                  <td>${element.existencias}</td>
                  <td>${NombreCat}</td>
                  <td>
                    <img src="${element.foto}" alt="Imagen" height="100" width="100" onclick='vistaPrevia(${JSON.stringify(element)})' class="btn">
                  </td>
                  <td>
                    <input type="radio" name="checkOpcion" id="checkOpcion" onclick='load(${JSON.stringify(element)})'>
                  </td>
                </tr>`;
    });
    tablaPro.innerHTML = data;
  } catch (error) {
    console.error(error);
  }
}


function vistaPrevia(element) {
  // Construimos el contenido del cuadro de diálogo de SweetAlert con los datos del producto
  const contenido = `
    <h3>${element.nombre}</h3>
    <img src="${element.foto}" alt="Imagen" height="300" width="300">
    <p>${element.descripcion}</p>
    <p>Precio: $${element.precio}</p>
        `;

  // Mostramos el cuadro de diálogo de SweetAlert
  swal.fire({
    html: contenido,
  });
}

// carga los datos en el formulario para modificar o eliminar
function load(element) {
  console.log(element);
  this.id = element.id;
  txtNombre.value = element.nombre;
  txtDescripcion.value = element.descripcion;
  txtPrecio.value = element.precio;
  txtCantidad.value = element.existencias;
  cbCategoria.value = element.categoria;
  vistaPreviaFoto.src = element.foto;
}

// Agregar productos a la base de datos
function agregarPro() {
  var csrfToken = document.getElementsByName("csrfmiddlewaretoken")[0].value;
  var fileInput = document.getElementById("fileFoto");
  var file = fileInput.files[0];

  var formData = new FormData();
  formData.append("nombre", txtNombre.value);
  formData.append("descripcion", txtDescripcion.value);
  formData.append("precio", txtPrecio.value);
  formData.append("existencias", txtCantidad.value);
  formData.append("categoria", cbCategoria.value);
  formData.append("foto", file);

  axios
    .post("/api/v1.0/productos/", formData, {
      headers: {
        "X-CSRFToken": csrfToken,
        "Content-Type": "multipart/form-data",
      },
    })
    .then(function (response) {
      swal.fire({ icon: "success", title: "Producto Agregado" });
      obtenerProductos();
      limpiar();
    })
    .catch(function (error) {
      console.error("Error al agregar ", error);
      swal.fire({
        icon: "error",
        title: "Oops...",
        text: `${error.response.data}`,
      });
    });
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
      Swal.fire("Eliminado!", "Su Producto ha sido Eliminado.", "success");
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
