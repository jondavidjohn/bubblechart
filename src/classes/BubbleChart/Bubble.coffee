class BubbleChart.Bubble
  constructor: (options) ->
    @grabbed = false
    @href = options.href
    @color = options.color
    @borderColor = options.borderColor
    @radius = options.radius
    @position = new BubbleChart.Point(options.x, options.y)
    @velocity =
      x: 0
      y: 0

  updateVelocity: (x, y) ->
    @velocity.x = x
    @velocity.y = y
