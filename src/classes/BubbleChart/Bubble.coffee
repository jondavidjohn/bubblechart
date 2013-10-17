class BubbleChart.Bubble

  constructor: (o) ->
    @grabbed = false
    @bully = false
    @pointOfGravity = o.pointOfGravity
    @href = o.href
    @label = o.label
    @metric = o.metric
    @data = o.data
    @img_src = o.img_src
    @fillColor = o.fillColor
    @borderColor = o.borderColor
    @textColor = o.textColor
    @textFont = o.textFont or "helvetica"
    @borderSize = o.borderSize
    @radius = o.radius
    @position = o.position
    @diameter = @radius * 2
    @reach = @radius + 1
    @img_area = o.img_area or 0.8
    if @borderSize?
      @reach += @borderSize

    @popover = new BubbleChart.Popover(@, o.popoverOpts or {})

    @pre = null
    @img = new Image()
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

      context.drawImage( @pre,
        @last_draw.x,
        @last_draw.y,
        @last_draw.w,
        @last_draw.h
      )

  render: () ->
    if @img_src?
      @img.onload = () =>
        canvas = document.createElement 'canvas'
        ctx = canvas.getContext '2d'
        bsRatio = BubbleChart.getBackingStoreRatio ctx

        if @img_src.indexOf('@2x') is not -1
          @img.height = @img.height / 2
          @img.width = @img.width / 2
        else if bsRatio > 1
          @img.height = @img.height / bsRatio
          @img.width = @img.width / bsRatio

        while @img.width > @diameter * @img_area
          @img.height = @img.height * 0.75
          @img.width = @img.width * 0.75
        canvas.height = @img.height
        canvas.width = @img.width + 2
        img_arc_x = @img.width / 2 + 2
        img_arc_y = @img.height / 2
        img_arc_r = @img.width / 2
        ctx.save()
        ctx.beginPath()
        ctx.arc img_arc_x, img_arc_y, img_arc_r, 0, Math.PI * 2, true
        ctx.closePath()
        ctx.clip()
        ctx.drawImage @img, 1, 0, @img.width, @img.height
        ctx.restore()
        ctx.arc img_arc_x, img_arc_y, @img.width / 2, 0, Math.PI * 2, true
        ctx.lineWidth = 1
        ctx.strokeStyle = @fillColor
        ctx.stroke()
        pre_ctx = @pre.getContext '2d'
        pre_ctx.drawImage( canvas,
          @radius - (canvas.width / 2),
          @radius - ((@img.height - @img.width) / 2) - (@img.width / 2),
          canvas.width,
          canvas.height
        )
      @img.src = @img_src
    @pre = document.createElement 'canvas'
    pre_context = @pre.getContext '2d'
    ratio = BubbleChart.getPixelRatio pre_context
    @pre.height = @pre.width = (@diameter + 3) * ratio
    pre_context.beginPath()
    pre_context.fillStyle = @fillColor
    pre_context.arc @radius + 1, @radius + 1, @radius, 0, Math.PI * 2, true
    pre_context.fill()

    if @borderColor?
      pre_context.lineWidth = @borderSize
      pre_context.strokeStyle = @borderColor
      pre_context.stroke()

    if @textColor
      pre_context.font = "#{20 * ratio}px '#{@textFont}'"
      pre_context.fillStyle = @textColor
      text_measurement = pre_context.measureText @label
      if text_measurement.width + 12 < @diameter
        spacingX = @radius - (text_measurement.width / 2)
        spacingY = @radius + (14 / 2)
        pre_context.fillText @label, spacingX, spacingY
      else
        pre_context.font = "#{12 * ratio}px helvetica"
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
      context.clearRect(
        @last_draw.x - 5,
        @last_draw.y - 5,
        @last_draw.w + 10,
        @last_draw.h + 10
      )
      @last_draw = null
