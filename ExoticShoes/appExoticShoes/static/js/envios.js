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
  await obtenerEnvios();
  dataTable = $("#tablaEnvio").DataTable(dataTableOptions);
  dataTableIsInitialized = true;
};

async function obtenerEnvios() {
    try {
        const response = await axios.get('/api/v1.0/envio/');
        console.log(response);
        let data = "";
        response.data.forEach((element, index) => {
            data += `<tr>
                        <th scope="row">${index + 1}</th>
                        <td>${element.servicioEnvio}</td>
                        <td>${element.DireccionEnv}</td>
                        <td>${element.fechaEnvio}</td>
                        <td>${element.fechaEntrega}</td>
                        <td>${element.estado}</td>
                        <td>${element.estadoPago}</td>
                    </tr>`;
        });
        table.innerHTML = data;
    } catch (error) {
        console.error(error);
    }
}

window.onload = function () {
    initDataTable();
  };
  