// Variales Globales
let id = 0;
let dataTable;
let dataTableIsInitialized = false;
let images = [];

const dataTableOptions = {
     dom: 'Bfrtip',
     buttons: ['copy', 'csv', 'excel', 'pdf', {
          extend: 'print',
          exportOptions: {
               stripHtml: false,
               columns: [0, 1, 2, 3, 4, 5, 6, 7]
          }
     }],
     columDefs: [
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
     await getProducts();
     dataTable = $("#tables").DataTable(dataTableOptions);
     dataTableIsInitialized = true;
};

async function getCategory() {
     try {
          const response = await axios.get('/api/v1.0/categorias/');
          localStorage.categoria = JSON.stringify(response.data);
          let opcion = `<option value="0">Seleccione una Categoría</option>`;
          response.data.forEach(element => {
               opcion += `<option value="${element.id}">${element.nombre}</option>`;
          });
          cbCategoria.innerHTML = opcion;
     } catch (error) {
          console.error(error);
     }
}

async function getProducts() {
     try {
          let product = "";
          let categoryName = "";
          const response = await axios.get('/api/productos');
          let categorias = JSON.parse(localStorage.categoria);
          response.data.forEach((element, index) => {
               categorias.forEach((categoria) => {
                    if (categoria.id === element.categoria) {
                         categoryName = categoria.nombre;
                    }
               });
               // Formatear el precio con separador de miles y el símbolo COP
               const precioFormateado = new Intl.NumberFormat("es-CO", {
                    style: "currency",
                    currency: "COP",
               }).format(element.precio);
               product += `<tr>
                              <th scope="row">${index + 1}</th>
                              <td>${element.nombre}</td>
                              <td>${element.descripcion}</td>
                              <td>${precioFormateado}</td>
                              <td>${categoryName}</td>
                              <td>
                                   <img src="${element.imagen}" alt="Imagen" height="100" width="100" class="rounded">
                              </td>
                              <td> 
                                   <div class="form-check">
                                        <input type="radio" name="checkOpcion" id="checkOpcion" onclick='load(${JSON.stringify(element)})' class="form-check-input">
                                        <label class="form-check-label" for="checkOpcion">Seleccionar</label>&nbsp;
                                   </div>
                                   &nbsp;
                                   <a name="verStock" id="cerStock" onClick='viewImage(${JSON.stringify(element)})'title="Ver Stock" class="btn btn-outline-secondary">
                                        <i class="fa-solid fa-boxes-stacked"></i> Stock
                                   </a>
                              </td>
                         </tr>`;
          });
          tablaPro.innerHTML = product;
     } catch (error) {
          console.error(error);
     }
}

async function addProducts() {

}

async function mostrar() {
     const file = fileFoto.files[0]
     if (file) {
          const reader = new FileReader();
          reader.onload = function (e) {
               vistaPrevia.src = e.target.result;
               vistaPrevia.style.display = 'block';
          };
          reader.readAsDataURL(file);
     } else {
          vistaPrevia.src = e.target.result;
          vistaPrevia.style.display = 'none';
     }
}

function vistaImagenFrm() {
     url = vistaPrevia.src
     Swal.fire({
          imageUrl: url,
          imageAlt: 'Custom image',
     })
}
window.addEventListener("load", async () => {
     await initDataTable();
     await getCategory();
});