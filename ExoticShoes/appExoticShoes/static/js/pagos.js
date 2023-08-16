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
    { searchable: true, targets: [0,1,2] }
  ],
  pageLength: 4,
  destroy: true,
  responsive: true,
  rowReorder: {
    selector: 'td:nth-child(2)'
}
};

const initDataTable = async () => {
  if (dataTableIsInitialized) {
    dataTable.destroy();
  }
  await obtenerPago();
  dataTable = $("#tablaPago").DataTable(dataTableOptions);
  dataTableIsInitialized = true;
};


async function obtenerPago() {
    try {
        const response = await axios.get('/api/v1.0/pago/');
        console.log(response);
        let data = "";
        response.data.forEach((element, index) => {
            data += `<tr>
                        <th scope="row">${index + 1}</th>
                        <td>${element.metodo}</td>
                        <td>${element.monto}</td>
                        <td>${element.fecha}</td>
                        <td>${element.estado}</td>
                        <td>${element.pedidos}</td>
                    </tr>`;
        });
        tablepagos.innerHTML = data;
    } catch (error) {
        console.error(error);
    }
}

window.onload = function () {
    initDataTable();
  };