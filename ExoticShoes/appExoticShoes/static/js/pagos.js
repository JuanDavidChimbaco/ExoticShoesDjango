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

window.addEventListener("load", async () => {
    await obtenerPago();
  });
  