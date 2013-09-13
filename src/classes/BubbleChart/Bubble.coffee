class BubbleChart.Bubble

  constructor: (o) ->
    @grabbed = false
    @bully = false
    @pointOfGravity = o.pointOfGravity
    @href = o.href
    @label = o.label
    @metric = o.metric
    @data = o.data
    @fillColor = o.fillColor
    @borderColor = o.borderColor
    @textColor = o.textColor
    @textFont = o.textFont or "helvetica"
    @borderSize = o.borderSize
    @radius = o.radius
    @position = o.position
    @diameter = @radius * 2
    @reach = @radius
    if @borderSize?
      @reach += @borderSize

    @popover = new BubbleChart.Popover(@, o.popoverOpts or {})

  getVelocity: () ->
    x: 0.04 * (@pointOfGravity.x - @position.x)
    y: 0.04 * (@pointOfGravity.y - @position.y)

  advance: (chart) ->
    if @grabbed
      p = chart.pointer
      if p.current? and p.diff?
        @position.x = p.current.x - p.diff.x
        @position.y = p.current.y - p.diff.y
    else
      v = @getVelocity()
      @position.x += v.x
      @position.y += v.y

  distanceFrom: (bubble) ->
    @position.distance(bubble.position) - (@reach + bubble.reach)

  overlapsWith: (bubble) ->
    @distanceFrom(bubble) < 0

  hasSpatialInferiorityTo: (bubble) ->
    (bubble.radius > @radius and not @grabbed) or
    bubble.grabbed or
    (bubble.bully and not @grabbed)

  resolveCollisionWith: (bubble) ->
    if @overlapsWith bubble
      currentDistance = @position.distance bubble.position
      currentRealDistance = @distanceFrom bubble
      targetDistance = currentDistance - currentRealDistance
      if @hasSpatialInferiorityTo bubble # move @
        rAngle = @position.rAngle bubble.position
        @position.x = bubble.position.x + targetDistance * Math.cos rAngle
        @position.y = bubble.position.y + targetDistance * Math.sin rAngle
        @bully = true
      else # move bubble
        rAngle = bubble.position.rAngle @position
        bubble.position.x = @position.x + targetDistance * Math.cos rAngle
        bubble.position.y = @position.y + targetDistance * Math.sin rAngle
        bubble.bully = true

  pushAwayFromEdges: (canvas, gutter) ->
    if @position.y - @reach + gutter < 0
      @position.y = @reach - gutter
      @bully = true
    else if @position.y + @reach - gutter > canvas.height
      @position.y = canvas.height - @reach + gutter
      @bully = true
    else if @position.x + @reach - gutter > canvas.width
      @position.x = canvas.width - @reach + gutter
      @bully = true
    else if @position.x - @reach + gutter < 0
      @position.x = @reach - gutter
      @bully = true

  paint: (context) ->
    context.beginPath()
    context.fillStyle = @fillColor
    context.arc @position.x, @position.y, @radius, 0, Math.PI * 2, true
    context.fill()

    if @borderColor?
      context.lineWidth = @borderSize
      context.strokeStyle = @borderColor
      context.stroke()

    if @textColor
      context.font = "20px '#{@textFont}'"
      context.fillStyle = @textColor
      text_measurement = context.measureText @label
      if text_measurement.width + 12 < @diameter
        spacingX = @position.x - (text_measurement.width / 2)
        spacingY = @position.y + (14 / 2)
        context.fillText @label, spacingX, spacingY
      else
        context.font = "12px helvetica"
        text_measurement = context.measureText @label
        if text_measurement.width + 7 < @diameter
          spacingX = @position.x - (text_measurement.width / 2)
          spacingY = @position.y + (4 / 2)
          context.fillText @label, spacingX, spacingY
        else
          truncated_label = "#{@label}..."
          while truncated_label and text_measurement.width + 7 >= @diameter
            truncated_label = truncated_label
              .substr(0, truncated_label.length - 4)
              .concat('...')

            truncated_label = false if truncated_label is '...'
            text_measurement = context.measureText truncated_label

          if truncated_label
            spacingX = @position.x - (text_measurement.width / 2)
            spacingY = @position.y + (4 / 2)
            context.fillText truncated_label, spacingX, spacingY

    context.closePath()
