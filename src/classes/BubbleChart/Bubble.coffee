class BubbleChart.Bubble

  ###
  # BubbleChart.Bubble
  #
  #  Options
  #
  #   - pointOfGravity / Point to which this bubble with move
  #     towards (BubbleChart.Point)
  #   - href / The href to be opened on single click
  #   - label / Name of the bubble
  #   - color / Fill color of the bubble
  #   - borderColor / The color of the border
  #   - textColor / The color of the text
  #   - borderSize / The size of the border
  #   - radius / The radius of the bubble
  #   - position / The center position of the bubble (BubbleChart.Point)
  #
  ###
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
    @textType = o.textType
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

  resolveCollisionWith: (bubble) ->
    currentDistance = @position.distance bubble.position
    currentRealDistance = @distanceFrom bubble
    if currentRealDistance < 0
      targetDistance = currentDistance - currentRealDistance
      if (bubble.radius > @radius and not @grabbed) or
      bubble.grabbed or
      (bubble.bully and not @grabbed)
        rAngle = @position.rAngle bubble.position
        @position.x = bubble.position.x + targetDistance * Math.cos rAngle
        @position.y = bubble.position.y + targetDistance * Math.sin rAngle
        @position.bully = true
      else
        rAngle = bubble.position.rAngle @position
        bubble.position.x = @position.x + targetDistance * Math.cos rAngle
        bubble.position.y = @position.y + targetDistance * Math.sin rAngle
        bubble.bully = true

  paint: (context) ->

    context.beginPath()
    context.fillStyle = @fillColor
    context.arc @position.x, @position.y, @radius, 0, Math.PI * 2, true
    context.fill()

    if @borderColor?
      context.lineWidth = @borderSize
      context.strokeStyle = @borderColor
      context.stroke()

    if @textColor?
      context.font = "20px helvetica"
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
