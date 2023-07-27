var id = 0;
document.addEventListener("DOMContentLoaded", function() {
  new DataTable('#tablaPro', {
    dom: 'Bfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    // Aquí puedes añadir más opciones si lo deseas
  });
});
async function obtenerPed() {
  try {
    var data = "";
    const response = await axios.get("/api/v1.0/pedidos/");
    console.log(response);

    if (response.data.length === 0) {
      tabla.innerHTML = "<tr><td colspan='5'>No se encontraron pedidos.</td></tr>";
    } else {
      response.data.forEach((element, index) => {
        data += `<tr>
                      <th scope="row">${index + 1}</th>
                      <td>COD000${element.id}</td>
                      <td>${element.fechaPedido}</td>
                      <td>${usuario}</td>
                      <td>
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal" onclick="detallePedidos('${element.id}')">
                          Detalles
                        </button>
                      </td>
                   </tr>`;
      });
    }
    
    tablaPro.innerHTML = data;
  } catch (error) {
    console.error(error);
  }
}


async function detallePedidos(id) {
  try {
    const response = await axios.delete(`/api/v1.0/detallePedidos`);
    console.log(response);
  } catch (error) {
    console.log(error);
  }
}


window.onload = function () {
  obtenerPed();
};
