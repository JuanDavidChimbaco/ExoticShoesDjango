var id = 0;
let dataTable;
let dataTableIsInitialized = false;

const estadosPedido = [
    {value: 'pendiente', label: 'Pendiente'},
    {value: 'confirmado', label: 'Confirmado'},
    {value: 'devuelto', label: 'Devuelto'},
];

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
                columns: [0, 1, 2, 3, 4, 5],
            },
        },
    ],
    columnDefs: [
        {className: 'centered', targets: [0, 1, 2, 3, 4]},
        {orderable: false, targets: [4]},
        {searchable: false, targets: []},
    ],
    pageLength: 4,
    destroy: true,
    responsive: true,
};

const initDataTable = async () => {
    if (dataTableIsInitialized) {
        dataTable.destroy();
    }
    await listOrders();
    dataTable = $('#tableOrder').DataTable(dataTableOptions);
    dataTableIsInitialized = true;
};

async function listOrders() {
    try {
        let data = '';
        const response = await axios.get('/api/v1.0/pedidos/');
        console.log(response.data);
        if (!response.data) {
            tableBody.innerHTML = "<tr><td colspan='6'>No se encontraron pedidos.</td></tr>";
        } else {
            for (const element of response.data) {
                let userName = await getUser(element.usuario);

                // Select de estados del pedido
                let estadoPedidoSelect = `<select id="estadoPedido_${element.id}" class="form-select" onchange="updateEstadoPedido(${element.id}, this.value)">`;
                estadosPedido.forEach((estado) => {
                    estadoPedidoSelect += `<option value="${estado.value}" ${element.estadoPedido === estado.value ? 'selected' : ''}>${estado.label}</option>`;
                });
                estadoPedidoSelect += `</select>`;

                data += `<tr>
                      <th scope="row">${element.id}</th>
                      <td>${element.codigoPedido}</td>
                      <td>${estadoPedidoSelect}</td>
                      <td>${element.fechaPedido}</td>
                      <td>${userName}</td>
                      <td>$${element.total}</td>
                      <td>
                        <button type="button" class="btn buttons2" data-bs-toggle="modal" data-bs-target="#exampleModal" onclick="detallePedidos('${element.id}')">
                          Detalles
                        </button>
                      </td>
                   </tr>`;
            }
        }
        tableBody.innerHTML = data;
    } catch (error) {
        console.error(error);
    }
}

async function updateEstadoPedido(pedidoId, nuevoEstado) {
    try {
        axios.defaults.xsrfCookieName = 'csrftoken'; // Nombre de la cookie CSRF
        axios.defaults.xsrfHeaderName = 'X-CSRFToken'; // Nombre del encabezado CSRF;
        const response = await axios.patch(`/api/v1.0/pedidos/${pedidoId}/`, {
            estadoPedido: nuevoEstado,
        });
        // Verificar si la solicitud se completó con éxito
        if (response.status === 200) {
            // Actualizar la vista con el nuevo estado (si es necesario)
            await listOrders();
        } else {
            console.error('No se pudo actualizar el estado del pedido.');
        }
    } catch (error) {
        console.error(error);
    }
}

async function getUser(id) {
    try {
        const response = await axios.get(`/api/v1.0/usuarios/${id}`);
        return response.data.username;
    } catch (error) {}
}

async function detallePedidos(pedidoId) {
    console.log(pedidoId);
    try {
        let data = '';
        const response = await axios.get(`/api/v1.0/pedidos/${pedidoId}/detalles/`);
        console.log(response);
        for (const [index, item] of response.data.entries()) {
            let producto = await getProduct(item.producto);
            let pedido = await getOrder(item.pedido);
            let talla = await getSize(item.talla);
            data += `<tr>
                  <th scope="row">${index + 1}</th>
                  <td>${pedido}</td>
                  <td>${producto}</td>
                  <td>${talla}</td>
                  <td>${item.cantidad}</td>
                  <td>${item.subtotal}</td>
              </tr>`;
        }

        tableDetalle.innerHTML = data;
    } catch (error) {
        console.log(error);
    }
}

async function getProduct(id) {
    try {
        const response = await axios.get(`/api/v1.0/productos/${id}/`);
        return response.data.nombre;
    } catch (error) {
        console.error(error);
    }
}

async function getOrder(id) {
    try {
        const response = await axios.get(`/api/v1.0/pedidos/${id}/`);
        return response.data.codigoPedido;
    } catch (error) {
        console.error(error);
    }
}

async function getSize(id) {
    try {
        const response = await axios.get(`/api/v1.0/tallas/${id}/`);
        return response.data.talla;
    } catch (error) {
        console.error(error);
    }
}

window.onload = function () {
    initDataTable();
};
