// Generated by CoffeeScript 1.8.0
(function() {
  var ScrollAnimation, calculatePhotoHeightForWindow, closePhotoshoot, openPhotoshoot, resize, resizeBody, resizePhoto, resizePhotoshoot,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.onload = function(event) {
    var coverPhotos, openPhotoshootLinks;
    resize(event);
    window.onresize = resize;
    document.body.classList.add("loaded");
    coverPhotos = document.body.querySelectorAll("div.photoshoot > div.cover > img");
    openPhotoshootLinks = document.body.querySelectorAll("div.photoshoot > div.cover > p > a");
    return document.body.addEventListener("click", function(event) {
      var el, _ref, _ref1;
      if (_ref = event.target, __indexOf.call(coverPhotos, _ref) >= 0) {
        event.preventDefault();
        el = event.target.parentElement.parentElement;
        if (el.classList.contains("open")) {
          closePhotoshoot(el);
        } else {
          openPhotoshoot(el);
        }
      }
      if (_ref1 = event.target, __indexOf.call(openPhotoshootLinks, _ref1) >= 0) {
        event.preventDefault();
        el = event.target.parentElement.parentElement.parentElement;
        return openPhotoshoot(el);
      }
    });
  };

  openPhotoshoot = function(el) {
    var rightEdgeOfCoverWasAlmostOffscreen, rightEdgeOfCoverWasAtEdgeOfScreen, rightEdgeOfCoverWasOffscreen, rightXofEl;
    if (el.classList.contains("open")) {
      return;
    }
    el.classList.add("open");
    resizePhotoshoot(el);
    el.style.transition = "width 750ms ease-in-out";
    setTimeout((function() {
      return el.classList.add("opened");
    }), 750);
    rightXofEl = el.getBoundingClientRect().right;
    rightEdgeOfCoverWasAtEdgeOfScreen = rightXofEl === window.innerWidth;
    rightEdgeOfCoverWasOffscreen = rightXofEl > window.innerWidth;
    rightEdgeOfCoverWasAlmostOffscreen = (rightXofEl + window.innerWidth / 5) > window.innerWidth;
    resizeBody();
    if (rightEdgeOfCoverWasAtEdgeOfScreen) {
      new ScrollAnimation({
        scrollTo: window.scrollX + (window.innerWidth / 2)
      });
    }
    if (rightEdgeOfCoverWasOffscreen || rightEdgeOfCoverWasAlmostOffscreen) {
      return new ScrollAnimation({
        scrollTo: window.scrollX + rightXofEl - (window.innerWidth / 2)
      });
    }
  };

  closePhotoshoot = function(el) {
    el.classList.remove("opened");
    el.classList.remove("open");
    resizePhotoshoot(el);
    el.style.transition = "width 750ms ease-in-out";
    return setTimeout(resizeBody, 750);
  };

  calculatePhotoHeightForWindow = function() {
    return Math.max(320, window.innerHeight - (115 + 230));
  };

  resize = function(event) {
    var el, _i, _j, _len, _len1, _ref, _ref1;
    _ref = document.body.querySelectorAll("div.photoshoot img");
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      el = _ref[_i];
      resizePhoto(el);
    }
    _ref1 = document.body.querySelectorAll("div.photoshoot");
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      el = _ref1[_j];
      resizePhotoshoot(el);
    }
    return resizeBody();
  };

  resizePhoto = function(el) {
    return el.style.height = calculatePhotoHeightForWindow() + 'px';
  };

  resizePhotoshoot = function(el) {
    var closedWidth, coverElement, coverImage, currentWidth, img, openWidth, photosElement, _i, _len, _ref;
    coverElement = el.querySelector("div.cover");
    coverImage = el.querySelector("div.cover img");
    photosElement = el.querySelector("div.photos");
    closedWidth = coverImage.getBoundingClientRect().width;
    openWidth = -22;
    _ref = el.querySelectorAll("img");
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      img = _ref[_i];
      openWidth += img.getBoundingClientRect().width + 22;
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
    _ref = document.body.querySelectorAll('div.photoshoot');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      el = _ref[_i];
      bodyWidth += parseInt(el.style.width) + 22;
    }
    return document.body.style.width = bodyWidth + "px";
  };

  ScrollAnimation = (function() {
    if (window.requestAnimationFrame == null) {
      window.requestAnimationFrame = function(callback) {
        return setTimeout(callback, 15);
      };
    }

    function ScrollAnimation(params) {
      this.render = __bind(this.render, this);
      this.completeCallback = params.oncomplete;
      this.targetX = params.scrollTo;
      this.initialX = window.scrollX;
      this.delta = this.targetX - this.initialX;
      this.duration = this.delta * 0.33;
      window.requestAnimationFrame(this.render);
    }

    ScrollAnimation.prototype.render = function(time) {
      var pos, x;
      if (this.start === void 0) {
        this.start = time;
      }
      pos = Math.min(1, Math.max((time - this.start) / this.duration, 0));
      x = Math.round(this.initialX + this.delta * this.easeInQuad(pos));
      if (this.delta > 0 && x > this.targetX) {
        x = this.targetX;
      }
      if (this.delta < 0 && x < this.targetX) {
        x = this.targetX;
      }
      window.scrollTo(x, 0);
      if (x === this.targetX) {
        if (this.completeCallback) {
          return this.completeCallback();
        }
      } else {
        return requestAnimationFrame(this.render);
      }
    };

    ScrollAnimation.prototype.easeInQuad = function(pos) {
      return Math.pow(pos, 3);
    };

    return ScrollAnimation;

  })();

}).call(this);
