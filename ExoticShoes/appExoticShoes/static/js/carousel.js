function configCarousel() {
    const myCarouselElement = document.querySelector('#carouselExampleAutoplaying');

    const carousel = new bootstrap.Carousel(myCarouselElement, {
        interval: 2000,
        touch: false
    });
}

async function ultimosProductos(){
    try {
        url = '/api/v1.0/'
        const response = await axios.get('')
    } catch (error) {
        
    }
}

window.onload = () => {
    configCarousel();
};