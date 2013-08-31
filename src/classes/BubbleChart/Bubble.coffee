class BubbleChart.Bubble
  constructor: (o) ->
    @grabbed = false
    @href = o.href
    @label = o.label
    @color = o.color
    @borderColor = o.borderColor
    @radius = o.radius
    @position = o.position
    @velocity =
      x: o.vX || 0
      y: o.vY || 0

  draw: (context) ->
    console.log "drawing " + @color + " bubble at " + @position.x + "," + @position.y + " with a radius of " + @radius, @
    context.beginPath()
    context.fillStyle = @color
    context.arc(@position.x, @position.y, @radius, 0, Math.PI * 2, true)
    context.fill()
    context.closePath()


