var id = 0;
function obtenerPed() {
  var tabla = document.getElementById("tablaPro");
  var rows = [];
  axios
    .get("/api/v1.0/pedidos/")
    .then(function (response) {
      console.log(response);
      response.data.forEach((element, index) => {
        var row = `<tr>
                       <th scope="row">${index + 1}</th>
                       <td>COD000${element.id}</td>
                       <td>${element.fechaPedido}</td>
                       <td>${usuario}</td>
                       <td>
                         <input type="button" name="detalles" id="detalles" onclick='load(${JSON.stringify(
                           element
                         )})'>
                       </td>
                     </tr>`;
        rows.push(row);
      });
      tabla.innerHTML = rows.join("");
    })
    .catch(function (error) {
      console.error(error);
    });
}
function load(element) {
  console.log(element);
  this.id = element.id;
  txtNombre.value = element.nombre;
  txtDescripcion.value = element.descripcion;
  txtPrecio.value = element.precio;
  txtCantidad.value = element.cantidadEnInventario;
  cbCategoria.value = element.categoria;
}
function agregarPed() {
  var csrfToken = document.getElementsByName("csrfmiddlewaretoken")[0].value;
  var fileInput = document.getElementById("fileFoto");
  var file = fileInput.files[0];

  var formData = new FormData();
  formData.append("nombre", txtNombre.value);
  formData.append("descripcion", txtDescripcion.value);
  formData.append("precio", txtPrecio.value);
  formData.append("cantidadEnInventario", txtCantidad.value);
  formData.append("categoria", cbCategoria.value);
  formData.append("foto", file);

  axios
    .post("/api/v1.0/pedidos/", formData, {
      headers: {
        "X-CSRFToken": csrfToken,
        "Content-Type": "multipart/form-data",
      },
    })
    .then(function (response) {
      console.log("Producto agregado con éxito " + response);
      obtenerProductos();
      limpiar();
    })
    .catch(function (error) {
      console.error("Error al agregar ", error);
    });
}
function modificarPed() {
  var csrfToken = document.getElementsByName("csrfmiddlewaretoken")[0].value;
  var fileInput = document.getElementById("fileFoto");
  var file = fileInput.files[0];

  var formData = new FormData();
  formData.append("id", this.id);
  formData.append("nombre", txtNombre.value);
  formData.append("descripcion", txtDescripcion.value);
  formData.append("precio", txtPrecio.value);
  formData.append("cantidadEnInventario", txtCantidad.value);
  formData.append("categoria", cbCategoria.value);
  formData.append("foto", file);

  axios
    .put(`/api/v1.0/pedidos/${this.id}/`, formData, {
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
    });
}
function eliminarPed() {
  var csrfToken = document.getElementsByName("csrfmiddlewaretoken")[0].value;
  let rest = confirm("Seguro de eliminar el Producto? ");
  if (rest) {
    axios
      .delete(`/api/v1.0/pedidos/${this.id}/`, {
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
}
window.onload = function () {
  obtenerPed();
};
