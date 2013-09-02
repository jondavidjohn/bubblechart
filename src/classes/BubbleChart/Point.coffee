class BubbleChart.Point
  constructor: (@x, @y) ->

  slope: (point) ->
    rise = @y - point.y
    run = @x - point.x
    rise / run

  # In Degrees
  angle: (point) ->
    @rAngle(point) * 180 / Math.PI

  # In Radians
  rAngle: (point) ->
    Math.atan2(point.y - @y, point.x - @x)

  distance: (point) ->
    a = @x - point.x
    b = @y - point.y
    Math.sqrt((a * a) + (b * b))
