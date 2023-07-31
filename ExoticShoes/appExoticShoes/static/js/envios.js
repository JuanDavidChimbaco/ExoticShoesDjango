async function obtenerEnvios() {
    try {
        const response = await axios.get('/api/v1.0/envio/');
        console.log(response);
        let data = "";
        response.data.forEach((element, index) => {
            data += `<tr>
                        <th scope="row">${index + 1}</th>
                        <td>${element.servicioEnvio}</td>
                        <td>${element.DireccionEnv}</td>
                        <td>${element.fechaEnvio}</td>
                        <td>${element.fechaEntrega}</td>
                        <td>${element.estado}</td>
                        <td>${element.estadoPago}</td>
                    </tr>`;
        });
        tableEnvios.innerHTML = data;
    } catch (error) {
        console.error(error);
    }
}

window.addEventListener("load", async () => {
    await obtenerEnvios();
  });
  