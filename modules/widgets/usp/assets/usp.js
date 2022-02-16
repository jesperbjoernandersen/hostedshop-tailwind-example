$('.w-usp-items').slick({
    arrows: false,
    mobileFirst: true,
    autoplay: true,
    responsive: [
        {
            breakpoint: 769,
            settings: {
                slidesToShow: 2
            }
        },
        {
            breakpoint: 1025,
            settings: {
                slidesToShow: 3
            }
        },
        {
            breakpoint: 1201,
            settings: {
                slidesToShow: 4
            }
        }
    ]
})