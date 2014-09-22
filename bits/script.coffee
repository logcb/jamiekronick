$(window).on "load", (event) ->
  resize(event)
  document.body.classList.add("loaded")

$(window).on "resize", (event) ->
  resize(event)

$(document).on "click", "div.photoshoot div.cover a", (event) ->
  openPhotoShoot $(event.target).closest("div.photoshoot").get(0)

$(document).on "click", "div.photoshoot > div.cover > img", (event) ->
  el = event.target.parentElement.parentElement
  openPhotoShoot(el) unless el.classList.contains("open")

openPhotoShoot = (el) ->
  el.classList.add("open")
  resizePhotoShoot(el)
  el.style["transition"] = "width 750ms ease-in-out"
  setTimeout (-> el.classList.add("opened")), 750
  resizeBody()

closePhotoShoot = (el) ->
  el.classList.remove("open")
  resizePhotoShoot(el)
  el.style["transition"] = "width 750ms ease-in-out"
  setTimeout resizeBody, 750

resize = (event) ->
  resizePhotoImg(el) for el in $('div.photoshoot img').toArray()
  resizePhotoShoot(el) for el in $('div.photoshoot').toArray()
  resizeBody()

calculatePhotoHeightForWindow = ->
  window.innerHeight - (115 + 230)

resizePhotoImg = (el) ->
  el.style.height = calculatePhotoHeightForWindow() + 'px'

resizePhotoShoot = (el) ->
  coverElement = $(el).find("div.cover").get(0)
  coverImage = $(el).find("div.cover img").get(0)
  photosElement = $(el).find("div.photos").get(0)
  allImages = $(el).find("img").toArray()
  closedWidth = $(coverImage).width()
  openWidth = -22
  openWidth = openWidth + $(img).width() + 22 for img in allImages
  currentWidth = if el.classList.contains("open") then openWidth else closedWidth
  coverElement.style.width = closedWidth + 'px'
  photosElement.style.width = (openWidth-closedWidth) + 'px'
  el.style.width = currentWidth + 'px'
  el.style.height = calculatePhotoHeightForWindow() + 'px'
  el.style.transition = ""

resizeBody = ->
  bodyWidth = -22-22
  bodyWidth = bodyWidth + 22 + parseInt(el.style.width) for el in $('div.photoshoot').toArray()
  $(document.body).css width: bodyWidth
