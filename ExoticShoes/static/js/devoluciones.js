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
  destroy: true,
  responsive: true
};

const initDataTable = async () => {
  if (dataTableIsInitialized) {
    dataTable.destroy();
  }
  await obtenerDevoluiones();
  dataTable = $("#tablaDev").DataTable(dataTableOptions);
  dataTableIsInitialized = true;
};

async function obtenerDevoluiones() {
    try {
        const response = await axios.get('/api/v1.0/devoluciones/');
        console.log(response);
        let data = "";
        response.data.forEach((element, index) => {
            data += `<tr>
                        <th scope="row">${index + 1}</th>
                        <td>${element.fechaDevolucion}</td>
                        <td>${element.motivo}</td>
                        <td>${element.productosDevueltos}</td>
                        <td>${element.cantidadDevuelta}</td>
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
  