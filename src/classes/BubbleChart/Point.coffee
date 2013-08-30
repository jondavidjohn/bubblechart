class BubbleChart.Point
  constructor: (@x, @y) ->

  distanceBetween: (point) ->
    a = @x - point.x
    b = @y - point.y
    Math.sqrt((a * a) + (b * b))
