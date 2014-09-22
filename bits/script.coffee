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

class ScrollAnimation
  requestAnimationFrame: window.requestAnimationFrame or (callback) -> setTimeout(callback,15)
  easeInQuad: (pos) -> Math.pow(pos, 3)

  constructor: (params) ->
    @completeCallback = params.oncomplete
    @targetX = params.scrollTo
    @initialX = window.scrollX
    @delta = @targetX - @initialX
    @duration = @delta * 0.33
    requestAnimationFrame(@render)

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
