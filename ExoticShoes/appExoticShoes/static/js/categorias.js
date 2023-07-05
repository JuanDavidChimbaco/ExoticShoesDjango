// ---------------------Categorias-------------------------------
var id = 0;
function obtenerCat() {
    var tabla = document.getElementById('tabla');
    var rows = [];

    axios
        .get('/api/v1.0/categorias/')
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
function agregarCat() {
    var nombre = txtNombre.value.trim();
    if (nombre === '') {
        alert('La categoria no puede estar vacío');
        return
    }

    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    axios
        .post('/api/v1.0/categorias/', {
            nombre: txtNombre.value,
        },
            {
                headers: {
                    'X-CSRFToken': csrfToken
                }
            })
        .then(function (response) {
            console.log('Categoria agregado con éxito' + response);
            obtenerCat()
            txtNombre.value = ""
        })
        .catch(function (error) {
            console.log(error)
            let mensaje = error.response.data.nombre[0]
            alert(mensaje);
            txtNombre.value = ""
        });
};
function modificarCat() {
    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    console.log(this.id);
    axios.put(`/api/v1.0/categorias/${this.id}/`, {
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
            obtenerCat()
            txtNombre.value = ""
        })
        .catch(function (error) {
            console.log(error);
        })
}
function eliminarCat() {
    var csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    let rest = confirm("Seguro de eliminar el Rol? ")
    if (rest) {
        axios.delete(`/api/v1.0/categorias/${this.id}/`, {
            headers: {
                'X-CSRFToken': csrfToken
            }
        })
            .then(function (response) {
                console.log(response);
                obtenerCat()
                txtNombre.value = ""
            })
            .catch(function (error) {
                console.log(error);
                let mensaje = error.response.data.detail
                alert(mensaje);
            })
    }
}
function limpiar() {
    document.getElementById('txtNombre').value = ""
    var radioButtons = document.getElementsByName('checkOpcion');

    radioButtons.forEach(function (radioButton) {
        radioButton.checked = false;
    });
}

window.onload = function () {
    obtenerCat();
};
