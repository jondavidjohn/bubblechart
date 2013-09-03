class BubbleChart.Bubble
  constructor: (o) ->
    @grabbed = false
    @speed = o.speed
    @pointOfGravity = o.pointOfGravity
    @href = o.href
    @label = o.label
    @color = o.color
    @borderColor = o.borderColor
    @borderSize = o.borderSize
    @radius = o.radius
    @position = o.position

  getVelocity: () ->
    x: 0.04 * (@pointOfGravity.x - @position.x)
    y: 0.04 * (@pointOfGravity.y - @position.y)

  reach: () ->
    reach = @radius
    if @borderSize
      reach += @borderSize
    reach

  advance: (chart) ->
    if @grabbed
      m = chart.mouse
      if m.current? and m.diff?
        @position.x = m.current.x - m.diff.x
        @position.y = m.current.y - m.diff.y
    else
      v = @getVelocity()
      @position.x += v.x
      @position.y += v.y

  distanceFrom: (bubble) ->
    @position.distance(bubble.position) - (@reach() + bubble.reach())

  resolveCollisionWith: (bubble) ->
    currentDistance = @position.distance(bubble.position)
    currentRealDistance = @distanceFrom(bubble)
    if currentRealDistance < 0
      targetDistance = currentDistance - currentRealDistance
      if (bubble.radius > @radius and not @grabbed) or bubble.grabbed
        rAngle = bubble.position.rAngle @position
        @position.x = bubble.position.x + targetDistance * Math.cos(rAngle)
        @position.y = bubble.position.y + targetDistance * Math.sin(rAngle)
      else
        rAngle = @position.rAngle bubble.position
        bubble.position.x = @position.x + targetDistance * Math.cos(rAngle)
        bubble.position.y = @position.y + targetDistance * Math.sin(rAngle)

  paint: (context) ->
    context.beginPath()
    context.fillStyle = @color
    context.arc(@position.x, @position.y, @radius, 0, Math.PI * 2, true)
    context.fill()
    if @borderColor?
      context.lineWidth = @borderSize
      context.strokeStyle = @borderColor
      context.stroke()
    context.closePath()




