//= require "siema/dist/siema.min"

let carouselCards = []

document.addEventListener("turbolinks:before-cache", function() {
  if (carouselCards.length == 0) return

  const elements = document.querySelectorAll("[data-role='carousel-cards']")

  elements.forEach(element => { element.classList.remove("initialised") })
  carouselCards.forEach(carousel => { carousel.destroy(true) })

  carouselCards = []
})

document.addEventListener("turbolinks:load", function() {
  const elements = document.querySelectorAll("[data-role='carousel-cards']")

  if (elements.length == 0) return

  elements.forEach(element => {
    carouselCards = [...carouselCards, new Siema({
      selector: element,
      onInit: (() => element.classList.add("initialised")),
      onChange: carouselCardsChanged,
      perPage: { 400: 2, 768: 3 }
    })]

    element.dataset.carouselId = carouselCards.length - 1
  })


  const previousElements = document.querySelectorAll("[data-action='carousel-previous']")
  previousElements.forEach((element) => element.removeEventListener("click", carouselPrevious))
  previousElements.forEach((element) => element.addEventListener("click", carouselPrevious))

  const nextElements = document.querySelectorAll("[data-action='carousel-next']")
  nextElements.forEach((element) => element.removeEventListener("click", carouselNext))
  nextElements.forEach((element) => element.addEventListener("click", carouselNext))
})

function carouselCardsChanged() {
  const parent = this.selector.closest(".card-carousel")
  const nextElement = parent.querySelector("[data-action='carousel-next']")
  const previousElement = parent.querySelector("[data-action='carousel-previous']")

  previousElement.classList.toggle("card-carousel__control--disabled", this.currentSlide == 0)
  nextElement.classList.toggle("card-carousel__control--disabled", this.currentSlide + this.perPage >= parseInt(this.selector.dataset.max))
}

function carouselNext() {
  const carouselId = getCarouselId(this)
  carouselCards[carouselId].next()
}

function carouselPrevious() {
  const carouselId = getCarouselId(this)
  carouselCards[carouselId].prev()
}

function getCarouselId(element) {
  const carouselElement = element.closest(".card-carousel").querySelector("[data-role='carousel-cards']")
  return carouselElement.dataset.carouselId
}
