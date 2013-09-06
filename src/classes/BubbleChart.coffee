class @BubbleChart

  ###
  # BubbleChart
  #
  #  Possible Options (defaults):
  #
  #   - canvasId / The html id of the canvas element you wish to use
  #   - usedArea (.5) / A decimal representation of how much of the
  #     canvas you wish to use
  #   - data / Array of data to be used for Bubble generation
  #   - metric / A word description of the data metric you are using
  #   - colors ([]) / An optional color pallete to choose bubble colors from
  #   - fps (60) / How quickly each frame refresh will happen
  #   - borderColor / Global border color for all bubbles
  #   - textColor / Global textColor for all bubbles
  #   - textFont / Font choice for bubble text
  #   - borderSize / Global borderSize for all bubbles
  #
  # Data objects should have the following properties.  They override
  # the above options for their specific bubble if shadowed here.
  #
  #  {
  #    label: "Name of the thing",
  #    data: 10,
  #    metric: "this specific metric",
  #    borderColor: "#FFF",
  #    borderSize: 3,
  #    textSize: "20px",
  #    textFont: "helvetica"
  #  }
  #
  ###
  constructor: (o) ->
    @data = o.data
    @metric = o.metric
    @colors = o.fillColors or []
    @fps = o.fps or 60

    @canvas = document.getElementById o.canvasId

    # Pointer Setup
    @pointer = new BubbleChart.Pointer()

    do (c = @canvas) =>
      # Attach Canvas Mouse/Touch events
      c.onmousemove = c.ontouchmove = @pointer.e_move
      c.onmousedown = c.ontouchstart = @pointer.e_grab
      c.onmouseup = c.onmouseout = c.ontouchend = @pointer.e_release
      # Calculate Canvas Metrics
      c.area = c.height * c.width
      c.usableArea = c.area * (o.usedArea || 0.2)
      c.midpoint = new BubbleChart.Point(c.width/2, c.height/2)
      c.context = c.getContext '2d'

    @metricTotal = (d.data for d in @data).reduce (a, b) -> a + b

    @bubbles = []

    for d in @data

      randColor = @colors[BubbleChart.randMax @colors.length if @colors.length]
      opts =
        href: d.href
        label: d.label
        metric: d.metric or o.metric
        data: d.data
        fillColor: d.fillColor or randColor
        borderColor: d.borderColor or o.borderColor
        textColor: d.textColor or o.textColor
        textType: d.textType or o.textType
        borderSize: d.borderSize or o.borderSize
        radius: Math.sqrt(@canvas.usableArea * (d.data / @metricTotal)) / 2
        popoverOpts: o.popoverOpts
        position: new BubbleChart.Point(
          BubbleChart.randMax(Math.sqrt(@canvas.area)),
          BubbleChart.randMax(Math.sqrt(@canvas.area))
        )
        pointOfGravity: @canvas.midpoint

      @bubbles.push new BubbleChart.Bubble(opts)


  paint: (_loop = true) ->
    for b in @bubbles
      b.advance @
      for bubble in @bubbles
        if b.label isnt bubble.label and b.overlapsWith(bubble)
          b.resolveCollisionWith bubble

    @canvas.context.clearRect 0, 0, @canvas.width, @canvas.height

    if @pointer.bubble?
      document.body.style.cursor = "default" unless @pointer.bubble.grabbed
      @pointer.bubble = null unless @pointer.bubble.grabbed

    for b in @bubbles
      b.paint @canvas.context
      if @pointer.current? and not @pointer.grabbingBubble()
        if @canvas.context.isPointInPath @pointer.current.x, @pointer.current.y
          @pointer.bubble = b

    if @pointer.bubble?
      document.body.style.cursor = "pointer"
      @pointer.bubble.popover.paint @pointer, @canvas.context

    if _loop
      setTimeout (=> @paint()), 1000 / @fps

  @randMax: (max) ->
    Math.floor Math.random() * max


