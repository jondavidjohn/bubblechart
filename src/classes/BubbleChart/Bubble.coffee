class BubbleChart.Bubble
  constructor: (o) ->
    @grabbed = false
    @href = o.href
    @color = o.color
    @borderColor = o.borderColor
    @radius = o.radius
    @position = o.position
    @velocity =
      x: o.vX || 0
      y: o.vY || 0

