CanvasRenderingContext2D::roundedRect = (x, y, w, h, r) ->
  r = w / 2 if w < 2 * r
  r = h / 2 if h < 2 * r
  @moveTo x+r, y
  @arcTo  x+w, y,   x+w, y+h, r
  @arcTo  x+w, y+h, x,   y+h, r
  @arcTo  x,   y+h, x,   y,   r
  @arcTo  x,   y,   x+w, y,   r

Math::randMax = (max) ->
  Math.floor Math.random() * max
