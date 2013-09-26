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
    @reach = @radius + 1
    if @borderSize?
      @reach += @borderSize

    @popover = new BubbleChart.Popover(@, o.popoverOpts or {})

    @pre = null
    @last_draw = null

    @render()

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
    bubble.grabbed or
    (bubble.radius > @radius and not @grabbed) or
    (bubble.radius > @radius and (@bully and bubble.bully) and not @grabbed) or
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
    if @pre?
      @last_draw =
        x: @position.x - @radius
        y: @position.y - @radius
        w: @pre.width
        h: @pre.height

      context.drawImage @pre, @last_draw.x, @last_draw.y, @last_draw.w, @last_draw.h

  render: () ->
    @pre = document.createElement 'canvas'
    @pre.height = @pre.width = ((@diameter) + 3) * window.devicePixelRatio
    pre_context = @pre.getContext('2d');
    pre_context.beginPath()
    pre_context.fillStyle = @fillColor
    pre_context.arc @radius + 1, @radius + 1, @radius, 0, Math.PI * 2, true
    pre_context.fill()

    if @borderColor?
      pre_context.lineWidth = @borderSize
      pre_context.strokeStyle = @borderColor
      pre_context.stroke()

    if @textColor
      pre_context.font = "20px '#{@textFont}'"
      pre_context.fillStyle = @textColor
      text_measurement = pre_context.measureText @label
      if text_measurement.width + 12 < @diameter
        spacingX = @radius - (text_measurement.width / 2)
        spacingY = @radius + (14 / 2)
        pre_context.fillText @label, spacingX, spacingY
      else
        pre_context.font = "12px helvetica"
        text_measurement = pre_context.measureText @label
        if text_measurement.width + 7 < @diameter
          spacingX = @radius - (text_measurement.width / 2)
          spacingY = @radius + (4 / 2)
          pre_context.fillText @label, spacingX, spacingY
        else
          truncated_label = "#{@label}..."
          while truncated_label and text_measurement.width + 7 >= @diameter
            truncated_label = truncated_label
              .substr(0, truncated_label.length - 4)
              .concat('...')

            truncated_label = false if truncated_label is '...'
            text_measurement = pre_context.measureText truncated_label

          if truncated_label
            spacingX = @radius - (text_measurement.width / 2)
            spacingY = @radius + (4 / 2)
            pre_context.fillText truncated_label, spacingX, spacingY

    pre_context.closePath()


  clear: (context) ->
    if @last_draw?
      context.clearRect @last_draw.x, @last_draw.y, @last_draw.w, @last_draw.h
      @last_draw = null
