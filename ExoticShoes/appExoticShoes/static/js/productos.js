// ----------------------------Productos-----------------------------------
function mostrarVistaPrevia() {
    var fileInput = document.getElementById('fileFoto');
    var imagenMostrar = document.getElementById('vistaPreviaFoto');
  
    var archivo = fileInput.files[0];
    var lector = new FileReader();
  
    lector.onload = function(e) {
      imagenMostrar.src = e.target.result;
    };
  
    if (archivo) {
      lector.readAsDataURL(archivo);
    }
  }

function NombreCat() {

    axios
        .get('/api/v1.0/categorias/')
        .then(function (response) {
            console.log(response.data);
            localStorage.categoria = JSON.stringify(response.data)
            var opcion = `<option value="0">Seleccione Categoría</option>`
            response.data.forEach(categoria => {
                opcion += `<option value="${categoria.id}">${categoria.nombre}</option>`
            })
            cbCategoria.innerHTML = opcion;
        })
}
var id = 0;
function obtenerProductos() {
    var tabla = document.getElementById('tablaPro');
    var rows = [];
    var NombreCat = ""
    axios
        .get('/api/v1.0/productos/')
        .then(function (response) {
            console.log(response);
            response.data.forEach((element, index) => {
                let categorias = JSON.parse(localStorage.categoria)
                categorias.forEach(cat => {
                    if (cat.id === element.categoria) {
                        NombreCat = cat.nombre;
                    }
                })
                var row = `<tr>
                       <th scope="row">${index + 1}</th>
                       <td>${element.nombre}</td>
                       <td>${element.descripcion}</td>
                       <td>${element.precio}</td>
                       <td>${element.cantidadEnInventario}</td>
                       <td>${NombreCat}</td>
                       <td><a href=""><img src="${element.foto}" alt="Imagen" height="100" width="100"></a></td>
                       <td>
                         <input type="radio" name="checkOpcion" id="checkOpcion" onclick='load(${JSON.stringify(element)})'>
                       </td>
                     </tr>`;
                rows.push(row);
            });
            tabla.innerHTML = rows.join('');
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
function agregarPro() {
    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    var fileInput = document.getElementById('fileFoto');
    var file = fileInput.files[0];

    var formData = new FormData();
    formData.append('nombre', txtNombre.value);
    formData.append('descripcion', txtDescripcion.value);
    formData.append('precio', txtPrecio.value);
    formData.append('cantidadEnInventario', txtCantidad.value);
    formData.append('categoria', cbCategoria.value);
    formData.append('foto', file);

    axios
        .post('/api/v1.0/productos/', formData,
            {
                headers: {
                    'X-CSRFToken': csrfToken,
                    'Content-Type': 'multipart/form-data'
                }
            })
        .then(function (response) {
            console.log('Producto agregado con éxito ' + response);
            obtenerProductos();
            limpiar();
        })
        .catch(function (error) {
            console.error('Error al agregar ', error);
        });
};
function modificarPro() {
    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    var fileInput = document.getElementById('fileFoto');
    var file = fileInput.files[0];

    var formData = new FormData();
    formData.append('id', this.id);
    formData.append('nombre', txtNombre.value);
    formData.append('descripcion', txtDescripcion.value);
    formData.append('precio', txtPrecio.value);
    formData.append('cantidadEnInventario', txtCantidad.value);
    formData.append('categoria', cbCategoria.value);
    formData.append('foto', file);

    axios.put(`/api/v1.0/productos/${this.id}/`, formData,
        {
            headers: {
                'X-CSRFToken': csrfToken,
                'Content-Type': 'multipart/form-data'
            }
        })
        .then(function (response) {
            console.log(response);
            obtenerProductos();
            limpiar();
        })
        .catch(function (error) {
            console.log(error);
        })
}
function eliminarPro() {
    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    let rest = confirm("Seguro de eliminar el Producto? ")
    if (rest) {
        axios.delete(`/api/v1.0/productos/${this.id}/`, {
            headers: {
                'X-CSRFToken': csrfToken
            }
        })
            .then(function (response) {
                console.log(response);
                obtenerProductos();
                limpiar();
            })
            .catch(function (error) {
                console.log(error);
            })
    }
}
function limpiar() {
    vistaPreviaFoto.src=""
    txtNombre.value = ""
    txtDescripcion.value = ""
    txtPrecio.value = ""
    txtCantidad.value = ""
    cbCategoria.value = 0
    fileFoto.value = ""
    var radioButtons = document.getElementsByName('checkOpcion');

    radioButtons.forEach(function (radioButton) {
        radioButton.checked = false;
    });
}
window.onload = function () {
    obtenerProductos();
    NombreCat();
};

