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
    { className: "centered", targets: [0, 1, 2, 3, 4] },
    { orderable: false, targets: [4] },
    { searchable: false, targets: [] }
  ],
  pageLength: 4,
  destroy: true
};

const initDataTable = async () => {
  if (dataTableIsInitialized) {
    dataTable.destroy();
  }
  await obtenerPed();
  dataTable = $("#tablaPro").DataTable(dataTableOptions);
  dataTableIsInitialized = true;
};
async function obtenerPed() {
  try {
    var data = "";
    const response = await axios.get("/api/v1.0/pedidos/");
    console.log(response.data);

    if (!response.data) {
      tabla.innerHTML = "<tr><td colspan='5'>No se encontraron pedidos.</td></tr>";
    } else {
      response.data.forEach((element, index) => {
        data += `<tr>
                      <th scope="row">${index + 1}</th>
                      <td>COD000${element.id}</td>
                      <td>${element.fechaPedido}</td>
                      <td>${element.usuario}</td>
                      <td>
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal" onclick="detallePedidos('${element.id}')">
                          Detalles
                        </button>
                      </td>
                   </tr>`;
      });
    }

    table.innerHTML = data;
  } catch (error) {
    console.error(error);
  }
}


async function detallePedidos(id) {
  console.log(id);
  try {
    let data = ""
    const response = await axios.get(`/api/v1.0/detallePedidos/${id}/`);
    console.log(response);
    const response2 = await axios.get(`/api/v1.0/productos/${response.data.producto}/`);
    console.log(response2);
      data = `<tr>
                  <th scope="row">${response.data.id}</th>
                  <td>${response.data.cantidad}</td>
                  <td>${response.data.subtotal}</td>
                  <td>COD000${response.data.pedido}</td>
                  <td>${response2.data.nombre}</td>
              </tr>`;
    tableDetalle.innerHTML = data;
  } catch (error) {
    console.log(error);
  }
}


window.onload = function () {
  initDataTable();
};
