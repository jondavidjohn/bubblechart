class BubbleChart.Popover

  ###
  # Hover Popover
  ###
  constructor : (bubble) ->
    @bubble = bubble
    @blockColor = '#333'
    @textColor = '#fff'
    @blockOpacity = 0.6
    @lineHeight = 20


  paint: (pointer, context) ->
    return unless pointer.current?

    context.font = '17px helvetica'
    label_measurement = context.measureText @bubble.label
    metric_measurement = context.measureText @bubble.metric
    lineWidth = if label_measurement.width > metric_measurement.width
        label_measurement.width + 15
      else
        metric_measurement.width + 15

    labelX = pointer.current.x - 14
    labelY = pointer.current.y - 26 - @lineHeight * 2
    triangle =
      x:0
      y:0
      x2:0
      y2:0
      x3:0
      y3:0

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
    context.fillStyle = @blockColor
    context.globalAlpha = @blockOpacity

    context.roundedRect labelX, labelY, lineWidth, @lineHeight * 2 + 10, 7

    context.moveTo triangle.x,  triangle.y
    context.lineTo triangle.x2, triangle.y2
    context.lineTo triangle.x3, triangle.y3
    context.lineTo triangle.x,  triangle.y
    context.fill()

    context.globalAlpha = 1

    context.fillStyle = @textColor
    context.fillText @bubble.label, labelX + 7, labelY + @lineHeight

    context.font = '11px helvetica'
    detailX = labelX + 7
    detailY = labelY + @lineHeight * 2
    context.fillText "#{@bubble.data} #{@bubble.metric}", detailX, detailY

    context.closePath()
