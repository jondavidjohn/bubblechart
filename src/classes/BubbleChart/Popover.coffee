class BubbleChart.Popover

  constructor : (bubble, o) ->
    @bubble = bubble
    @fillColor = o.fillColor or '#333'
    @textColor = o.textColor or '#FFF'
    @textFont = o.textFont or 'helvetica'
    @opacity = o.opacity or 0.8
    @labelSize = o.labelSize or 18
    @metricSize = o.metricSize or 12
    @popoverShowData = true
    if o.popoverShowData?
      @popoverShowData = o.popoverShowData
    @last_draw = null
    @textDems = {}
    @pre = null

  getTextDems: (context, text, size, font) ->
    if not @textDems["#{text}#{size}#{font}"]?
      # Width is easy
      context.font = "#{size}px '#{font}'"
      width = context.measureText(text).width

      # Height is a bit tricky
      d = document.createElement "span"
      d.style.fontSize = "#{size}px"
      d.style.fontFamily = font
      d.style.visibility = "hidden"
      d.textContent = text
      document.body.appendChild d
      height = d.offsetHeight
      document.body.removeChild d
      @textDems["#{text}#{size}#{font}"] =
        width: width
        height: height
    @textDems["#{text}#{size}#{font}"]

  calculateTriangle: (base_width, height, ratio) ->
    triangle =
      x: 0, y: 0
      x2:0, y2:0
      x3:0, y3:0

    triangle.x -= base_width / 2
    triangle.x2 = triangle.x + base_width / 2
    triangle.x3 = triangle.x + base_width

    if height > 0
      triangle.y += height - (26 * ratio)
    else
      triangle.y += height + (48 * ratio)

    triangle.y2 = triangle.y + height
    triangle.y3 = triangle.y

    triangle

  paint: (pointer, context) ->
    return unless pointer.current?
    ratio = BubbleChart.getPixelRatio context

    labelSize = @labelSize
    metricSize = @metricSize
    lr_pad = 8 * ratio
    tb_pad = 5 * ratio
    triangle_width = 16 * ratio
    triangle_height = 8 * ratio

    if this.popoverShowData
      metric_text = "#{@bubble.data} #{@bubble.metric}"
    else
      metric_text = "#{@bubble.metric}"

    l_dems = @getTextDems context, @bubble.label, labelSize, @textFont
    m_dems = @getTextDems context, metric_text, metricSize, @textFont

    lineWidth = (Math.max(l_dems.width, m_dems.width) + (lr_pad * 2)) * ratio
    lineHeight = Math.max(l_dems.height, m_dems.height) * ratio

    box_height = (lineHeight * 2) + (tb_pad * 2)

    labelX = pointer.current.x - (14 * ratio)
    labelY = pointer.current.y - box_height - triangle_height - (tb_pad * 2)

    if labelY < 0
      labelY = pointer.current.y + (40 * ratio)
      triangle = @calculateTriangle(triangle_width, - triangle_height, ratio)
    else
      triangle = @calculateTriangle(triangle_width, triangle_height, ratio)

    triangle.x += pointer.current.x
    triangle.y += pointer.current.y
    triangle.x2 += pointer.current.x
    triangle.y2 += pointer.current.y
    triangle.x3 += pointer.current.x
    triangle.y3 += pointer.current.y

    # right edge case
    if labelX + lineWidth > context.canvas.width
      labelX -= labelX + lineWidth - context.canvas.width

    @last_draw =
      x: labelX
      y: labelY - (triangle_height)
      w: lineWidth + 2
      h: box_height + (triangle_height * 2)

    context.beginPath()
    context.fillStyle = @fillColor
    context.globalAlpha = @opacity

    context.roundedRect labelX, labelY, lineWidth, box_height, 7 * ratio

    context.moveTo triangle.x,  triangle.y
    context.lineTo triangle.x2, triangle.y2
    context.lineTo triangle.x3, triangle.y3
    context.lineTo triangle.x,  triangle.y
    context.fill()

    context.globalAlpha = 1


    context.fillStyle = @textColor
    context.font = "#{labelSize * ratio}px #{@textFont}"
    context.fillText @bubble.label, labelX + lr_pad, labelY + lineHeight

    context.font = "#{metricSize * ratio}px #{@textFont}"
    detailX = labelX + lr_pad
    detailY = labelY + lineHeight * 2
    context.fillText metric_text, detailX, detailY

    context.closePath()


  clear: (context) ->
    if @last_draw?
      context.clearRect @last_draw.x, @last_draw.y, @last_draw.w, @last_draw.h
      @last_draw = null
