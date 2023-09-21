let dataTable;
let dataTableIsInitialized = false;

// Opciones para el DataTable
const dataTableOptions = {
    dom: 'Bfrtip',
    buttons: [
        'copy',
        'csv',
        'excel',
        'pdf',
        {
            extend: 'print',
            exportOptions: {
                columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
            },
        },
    ],
    columnDefs: [
        {className: 'centered', targets: []},
        {orderable: false, targets: []},
        {searchable: false, targets: []},
    ],
    pageLength: 10,
    destroy: true,
    responsive: true,
};

const initDataTable = async () => {
    if (dataTableIsInitialized) {
        dataTable.destroy();
    }
    await obtenerEnvios();
    dataTable = $('#tablaEnvio').DataTable(dataTableOptions);
    dataTableIsInitialized = true;
};

async function obtenerEnvios() {
    try {
        const response = await axios.get('/api/v1.0/envio/');
        console.log(response);
        let data = '';
        for (const [index, element] of response.data.entries()) {
            const pedido = await getOrder(element.pedido);
            data += `<tr>
                        <th scope="row">${index + 1}</th>
                        <td>${pedido}</td>
                        <td>${element.direccionEntrega}</td>
                        <td>${element.codigoPostal}</td>
                        <td>${element.ciudad}</td>
                        <td>${element.departamento}</td>
                        <td>${element.pais}</td>
                        <td>${element.costoEnvio}</td>
                        <td>${element.estadoEnvio}</td>
                        <td>${element.fechaEstimadaEntrega}</td>
                    </tr>`;
        }
        table.innerHTML = data;
    } catch (error) {
        console.error(error);
    }
}

async function getOrder(id) {
    try {
        const response = await axios.get(`/api/v1.0/pedidos/${id}`);
        return response.data.codigoPedido;
    } catch (error) {
        console.error(error);
    }
}

window.onload = function () {
    initDataTable();
};
