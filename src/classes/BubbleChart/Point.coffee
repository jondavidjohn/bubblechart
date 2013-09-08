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
    Math.atan2 @y - point.y, @x - point.x

  diff: (point) ->
    x: @x - point.x
    y: @y - point.y

  distance: (point) ->
    diff = @diff point
    Math.sqrt (diff.x * diff.x) + (diff.y * diff.y)
