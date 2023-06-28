// ---------------------Roles-------------------------------
var id = 0;
function obtenerRoles() {
    var tabla = document.getElementById('tabla');
    var rows = [];

    axios
        .get('/api/roles/')
        .then(function (response) {
            console.log(response);
            response.data.forEach((element, index) => {
                var row = `<tr>
                       <th scope="row">${index + 1}</th>
                       <td>${element.nombre}</td>
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
}
function agregarRoles() {
    var nombre = txtNombre.value.trim();
    if (nombre === '') {
        alert('El nombre del rol no puede estar vacío');
        return; // Salir de la función si el campo está vacío
    }

    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    axios
        .post('/api/roles/', {
            nombre: nombre.value,
        },
            {
                headers: {
                    'X-CSRFToken': csrfToken
                }
            })
        .then(function (response) {
            console.log('Rol agregado con éxito ' + response);
            obtenerRoles()
        })
        .catch(function (error) {
            console.error('Error al agregar el rol', error);
        });
};
function modificarRoles() {
    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    console.log(this.id);
    axios.put(`/api/roles/${this.id}/`, {
        id: this.id,
        nombre: txtNombre.value,
    },
        {
            headers: {
                'X-CSRFToken': csrfToken
            }
        })
        .then(function (response) {
            console.log(response);
            obtenerRoles()
        })
        .catch(function (error) {
            console.log(error);
        })
}
function eliminarRoles() {
    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    let rest = confirm("Seguro de eliminar el Rol? ")
    if (rest) {
        axios.delete(`/api/roles/${this.id}/`, {
            headers: {
                'X-CSRFToken': csrfToken
            }
        })
            .then(function (response) {
                console.log(response);
                obtenerRoles()
            })
            .catch(function (error) {
                console.log(error);
            })
    }
}
function limpiar() {
    var radioButtons = document.getElementsByName('checkOpcion');

    radioButtons.forEach(function (radioButton) {
        radioButton.checked = false;
    });
}
// ----------------------------Productos-----------------------------------

var id = 0;
function obtenerProductos() {
    var tabla = document.getElementById('tabla');
    var rows = [];

    axios
        .get('/api/productos/')
        .then(function (response) {
            console.log(response);
            response.data.forEach((element, index) => {
                var row = `<tr>
                       <th scope="row">${index + 1}</th>
                       <td>${element.nombre}</td>
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
}
function agregarRoles() {
    var nombre = txtNombre.value.trim();
    if (nombre === '') {
        alert('El nombre del rol no puede estar vacío');
        return; // Salir de la función si el campo está vacío
    }

    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    axios
        .post('/api/roles/', {
            nombre: nombre.value,
        },
            {
                headers: {
                    'X-CSRFToken': csrfToken
                }
            })
        .then(function (response) {
            console.log('Rol agregado con éxito ' + response);
            obtenerRoles()
        })
        .catch(function (error) {
            console.error('Error al agregar el rol', error);
        });
};
function modificarRoles() {
    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    console.log(this.id);
    axios.put(`/api/roles/${this.id}/`, {
        id: this.id,
        nombre: txtNombre.value,
    },
        {
            headers: {
                'X-CSRFToken': csrfToken
            }
        })
        .then(function (response) {
            console.log(response);
            obtenerRoles()
        })
        .catch(function (error) {
            console.log(error);
        })
}
function eliminarRoles() {
    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    let rest = confirm("Seguro de eliminar el Rol? ")
    if (rest) {
        axios.delete(`/api/roles/${this.id}/`, {
            headers: {
                'X-CSRFToken': csrfToken
            }
        })
            .then(function (response) {
                console.log(response);
                obtenerRoles()
            })
            .catch(function (error) {
                console.log(error);
            })
    }
}
function limpiar() {
    var radioButtons = document.getElementsByName('checkOpcion');

    radioButtons.forEach(function (radioButton) {
        radioButton.checked = false;
    });
}
window.onload = function () {
    obtenerRoles();
};

