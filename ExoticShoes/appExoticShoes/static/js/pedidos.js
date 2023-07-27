var id = 0;
document.addEventListener("DOMContentLoaded", function() {
  new DataTable('#tablaPro', {
    dom: 'Bfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    // Aquí puedes añadir más opciones si lo deseas
  });
});
function obtenerPed() {
  var tabla = document.getElementById("tablaPro");
  var rows = [];
  axios
    .get("/api/v1.0/pedidos/")
    .then(function (response) {
      console.log(response);
      if (response.data.length === 0) {
        tabla.innerHTML = "<tr><td colspan='5'>No se encontraron pedidos.</td></tr>";
      } else {
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
    }
      tabla.innerHTML = rows.join("");
    })
    .catch(function (error) {
      console.error(error);
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
