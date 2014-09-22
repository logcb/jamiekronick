// Generated by CoffeeScript 1.8.0
(function() {
  var calculatePhotoHeightForWindow, closePhotoShoot, openPhotoShoot, resize, resizeBody, resizePhotoImg, resizePhotoShoot;

  $(window).on("load", function(event) {
    resize(event);
    return document.body.classList.add("loaded");
  });

  $(window).on("resize", function(event) {
    return resize(event);
  });

  $(document).on("click", "div.photoshoot div.cover a", function(event) {
    return openPhotoShoot($(event.target).closest("div.photoshoot").get(0));
  });

  $(document).on("click", "div.photoshoot > div.cover > img", function(event) {
    var el;
    el = event.target.parentElement.parentElement;
    if (!el.classList.contains("open")) {
      return openPhotoShoot(el);
    }
  });

  openPhotoShoot = function(el) {
    el.classList.add("open");
    resizePhotoShoot(el);
    el.style["transition"] = "width 750ms ease-in-out";
    setTimeout((function() {
      return el.classList.add("opened");
    }), 750);
    return resizeBody();
  };

  closePhotoShoot = function(el) {
    el.classList.remove("open");
    resizePhotoShoot(el);
    el.style["transition"] = "width 750ms ease-in-out";
    return setTimeout(resizeBody, 750);
  };

  resize = function(event) {
    var el, _i, _j, _len, _len1, _ref, _ref1;
    _ref = $('div.photoshoot img').toArray();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      el = _ref[_i];
      resizePhotoImg(el);
    }
    _ref1 = $('div.photoshoot').toArray();
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      el = _ref1[_j];
      resizePhotoShoot(el);
    }
    return resizeBody();
  };

  calculatePhotoHeightForWindow = function() {
    return Math.max(320, window.innerHeight - (115 + 230));
  };

  resizePhotoImg = function(el) {
    return el.style.height = calculatePhotoHeightForWindow() + 'px';
  };

  resizePhotoShoot = function(el) {
    var allImages, closedWidth, coverElement, coverImage, currentWidth, img, openWidth, photosElement, _i, _len;
    coverElement = $(el).find("div.cover").get(0);
    coverImage = $(el).find("div.cover img").get(0);
    photosElement = $(el).find("div.photos").get(0);
    allImages = $(el).find("img").toArray();
    closedWidth = $(coverImage).width();
    openWidth = -22;
    for (_i = 0, _len = allImages.length; _i < _len; _i++) {
      img = allImages[_i];
      openWidth = openWidth + $(img).width() + 22;
    }
    currentWidth = el.classList.contains("open") ? openWidth : closedWidth;
    coverElement.style.width = closedWidth + 'px';
    photosElement.style.width = (openWidth - closedWidth) + 'px';
    el.style.width = currentWidth + 'px';
    el.style.height = calculatePhotoHeightForWindow() + 'px';
    return el.style.transition = "";
  };

  resizeBody = function() {
    var bodyWidth, el, _i, _len, _ref;
    bodyWidth = -22 - 22;
    _ref = $('div.photoshoot').toArray();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      el = _ref[_i];
      bodyWidth = bodyWidth + 22 + parseInt(el.style.width);
    }
    return $(document.body).css({
      width: bodyWidth
    });
  };

}).call(this);
