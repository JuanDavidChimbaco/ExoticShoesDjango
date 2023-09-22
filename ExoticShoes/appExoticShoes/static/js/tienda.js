function search() {
    fetch()
        .then((response) => response.json())
        .then((data) => {
            let buscar = document.getElementById('search').value;
            if (buscar.length >= 2) {
                document.getElementById('list-producto').classList.remove('hide');
                let List = '<div class="List-group">';
                const filtroproducto = data.results.filter(filtrarproducto);
                filtroproducto.forEach((producto) => {
                    iconoproducto(producto.url);
                    list += `<a onlcick="detalleproducto(${'producto.url'})" href="/nav.html" class="list-group-item list-group-item-action"> <img id="icono${pokemon.name}"> ${
                        producto.name
                    }</a>`;
                });
                list += '</div>';
                document.getElementById('List-product').innerHTML = list;
            } else {
                document.getElementById('list-producto').innerHTML = '';
                document.getElementById('list-producto').classList.add('hide');
            }
        });
}

function filtrarproducto(element) {
    let buscar = document.getElementById('search').value;
    let name = element.name;
    return name.includes(buscar.toLowerCase());
}
