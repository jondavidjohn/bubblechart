CanvasRenderingContext2D::roundedRect = (x, y, w, h, r) ->
  r = w / 2 if w < 2 * r
  r = h / 2 if h < 2 * r
  @moveTo x+r, y
  @arcTo  x+w, y,   x+w, y+h, r
  @arcTo  x+w, y+h, x,   y+h, r
  @arcTo  x,   y+h, x,   y,   r
  @arcTo  x,   y,   x+w, y,   r

Math.randInt = (max = 100) ->
  Math.floor Math.random() * max

# requestAnimationFrame Polyfill
do ->
  lastTime = 0
  vendors = ['webkit', 'moz']

  while not window.requestAnimationFrame and vendors.length
    v = vendors.pop()
    window.requestAnimationFrame = window[v+'RequestAnimationFrame']
    window.cancelAnimationFrame =
      window[v+'CancelAnimationFrame'] or
      window[v+'CancelRequestAnimationFrame']

  unless window.requestAnimationFrame
    console.log "janky polyfill"
    window.requestAnimationFrame = (cb, ele) ->
      currTime = new Date().getTime()
      timeToCall = Math.max(0, 16 - (currTime - lastTime))
      id = window.setTimeout (-> cb(currTime + timeToCall)), timeToCall
      lastTime = currTime + timeToCall
      return id

  unless window.cancelAnimationFrame
    window.cancelAnimationFrame = (id) ->
      clearTimeout id
