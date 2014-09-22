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
  el.style.transition = "width 750ms ease-in-out"
  setTimeout (-> el.classList.add("opened")), 750
  rightXofEl = el.getBoundingClientRect().right
  rightEdgeOfCoverWasAtEdgeOfScreen = rightXofEl is window.innerWidth
  rightEdgeOfCoverWasOffscreen = rightXofEl > window.innerWidth
  rightEdgeOfCoverWasAlmostOffscreen = (rightXofEl + window.innerWidth/5) > window.innerWidth
  resizeBody()
  if rightEdgeOfCoverWasAtEdgeOfScreen
    new ScrollAnimation
      scrollTo: window.scrollX + (window.innerWidth/2)
  if rightEdgeOfCoverWasOffscreen or rightEdgeOfCoverWasAlmostOffscreen
    new ScrollAnimation
      scrollTo: window.scrollX + rightXofEl - (window.innerWidth/2)

closePhotoShoot = (el) ->
  el.classList.remove("open")
  resizePhotoShoot(el)
  el.style.transition = "width 750ms ease-in-out"
  setTimeout resizeBody, 750

resize = (event) ->
  resizePhotoImg(el) for el in $('div.photoshoot img').toArray()
  resizePhotoShoot(el) for el in $('div.photoshoot').toArray()
  resizeBody()

calculatePhotoHeightForWindow = ->
  Math.max 320, window.innerHeight - (115 + 230)

resizePhotoImg = (el) ->
  el.style.height = calculatePhotoHeightForWindow() + 'px'

resizePhotoShoot = (el) ->
  coverElement = el.querySelector("div.cover")
  coverImage = el.querySelector("div.cover img")
  photosElement = el.querySelector("div.photos")
  closedWidth = $(coverImage).width()
  openWidth = -22
  openWidth += img.getBoundingClientRect().width + 22 for img in el.querySelectorAll("img")
  currentWidth = if el.classList.contains("open") then openWidth else closedWidth
  coverElement.style.width = closedWidth + 'px'
  photosElement.style.width = (openWidth-closedWidth) + 'px'
  el.style.width = currentWidth + 'px'
  el.style.height = calculatePhotoHeightForWindow() + 'px'
  el.style.transition = ""

resizeBody = ->
  bodyWidth = -22-22
  bodyWidth += parseInt(el.style.width) + 22 for el in document.body.querySelectorAll('div.photoshoot')
  document.body.style.width = bodyWidth + "px"

class ScrollAnimation
  window.requestAnimationFrame ?= (callback) -> setTimeout(callback,15)

  constructor: (params) ->
    @completeCallback = params.oncomplete
    @targetX = params.scrollTo
    @initialX = window.scrollX
    @delta = @targetX - @initialX
    @duration = @delta * 0.33
    window.requestAnimationFrame(@render)

  render: (time) =>
    @start = time if @start is undefined
    # calculate position of animation in [0..1]
    pos = Math.min(1, Math.max((time - @start)/@duration, 0))
    # calculate the new scroll position (don't forget to ease)
    x = Math.round(@initialX + @delta * @easeInQuad(pos))
    # bracket so we're never over-scrolling
    if (@delta > 0 and x > @targetX) then x = @targetX
    if (@delta < 0 and x < @targetX) then x = @targetX
    window.scrollTo(x, 0)
    if x is @targetX
      @completeCallback() if @completeCallback
    else
      requestAnimationFrame(@render)

  easeInQuad: (pos) ->
    Math.pow(pos, 3)
