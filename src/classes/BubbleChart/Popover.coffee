class BubbleChart.Popover

  constructor : (bubble, o) ->
    @bubble = bubble
    @fillColor = o.fillColor or '#333'
    @textColor = o.textColor or '#fff'
    @textFont = o.textFont or 'helvetica'
    @opacity = o.opacity or 0.8
    @lineHeight = 20
    @last_draw = null

  clear: (context) ->
    if @last_draw?
      context.clearRect @last_draw.x, @last_draw.y, @last_draw.w, @last_draw.h
      @last_draw = null

  paint: (pointer, context) ->
    return unless pointer.current?

    context.font = "17px '#{@textFont}'"
    label_measurement = context.measureText @bubble.label
    metric_measurement = context.measureText "#{@bubble.data} #{@bubble.metric}"
    lineWidth = if label_measurement.width > metric_measurement.width
        label_measurement.width + 15
      else
        metric_measurement.width + 15

    labelX = pointer.current.x - 14
    labelY = pointer.current.y - 26 - @lineHeight * 2
    triangle =
      x: 0, y: 0
      x2:0, y2:0
      x3:0, y3:0

    if labelY < 0
      labelY = pointer.current.y + 26
      triangle.y = pointer.current.y + 26
      triangle.y3 = triangle.y - 4
    else
      triangle.y  = pointer.current.y - 16
      triangle.y3 = pointer.current.y - 10

    # triangle setup
    triangle.x  = pointer.current.x - 8
    triangle.x2 = triangle.x + 16
    triangle.y2 = triangle.y
    triangle.x3 = triangle.x2 - 8

    # right edge case
    if labelX + lineWidth > context.canvas.width
      labelX -= labelX + lineWidth - context.canvas.width

    context.beginPath()
    context.fillStyle = @fillColor
    context.globalAlpha = @opacity

    @last_draw =
      x: labelX
      y: labelY
      w: lineWidth
      h: @lineHeight * 2 + 10 + (triangle.y3 - triangle.y) + 5

    context.roundedRect labelX, labelY, lineWidth, @lineHeight * 2 + 10, 7

    context.moveTo triangle.x,  triangle.y
    context.lineTo triangle.x2, triangle.y2
    context.lineTo triangle.x3, triangle.y3
    context.lineTo triangle.x,  triangle.y
    context.fill()

    context.globalAlpha = 1

    context.fillStyle = @textColor
    context.fillText @bubble.label, labelX + 7, labelY + @lineHeight

    context.font = "11px #{@textFont}"
    detailX = labelX + 7
    detailY = labelY + @lineHeight * 2
    context.fillText "#{@bubble.data} #{@bubble.metric}", detailX, detailY

    context.closePath()
