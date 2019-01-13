#= require jquery
#= require libs/bootstrap.min
#= require libs/tiny-slider
#= require feedback

tns(
  container: '.my-slider'
  items: 1
  slideBy: 'page'
  autoplay: true
  controls: false
  controlsPosition: 'bottom'
  navPosition: 'bottom'
  autoplayTimeout: 3000
)
