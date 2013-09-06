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

    # Calc Canvas metrics
    @canvas = document.getElementById o.canvasId
    @canvas.area = @canvas.height * @canvas.width
    @canvas.usableArea = @canvas.area * (o.usedArea || 0.2)
    @canvas.midpoint = new BubbleChart.Point(@canvas.width/2, @canvas.height/2)
    @canvas.context = @canvas.getContext '2d'

    # Pointer Setup
    @pointer = new BubbleChart.Pointer()
    @canvas.onmousemove = @canvas.ontouchmove = @pointer.e_move
    @canvas.onmousedown = @canvas.ontouchstart = @pointer.e_grab
    @canvas.onmouseup = @canvas.onmouseout = @canvas.ontouchend = @pointer.e_release

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
        borderSize: d.borderSize or o.borderSize
        radius: Math.sqrt(@canvas.usableArea * (d.data / @metricTotal)) / 2
        position: new BubbleChart.Point(
          BubbleChart.randMax(Math.sqrt(@canvas.area)),
          BubbleChart.randMax(Math.sqrt(@canvas.area))
        )
        pointOfGravity: @canvas.midpoint

      @bubbles.push new BubbleChart.Bubble(opts)


  paint: ->
    for b in @bubbles
      b.advance @
      for bubble in @bubbles
        if b.label isnt bubble.label and b.distanceFrom(bubble) < 0
          b.resolveCollisionWith bubble

    @canvas.context.clearRect 0, 0, @canvas.width, @canvas.height

    if @pointer.bubble?
      document.body.style.cursor = "default" unless @pointer.bubble.grabbed
      @pointer.bubble = null unless @pointer.bubble.grabbed

    for b in @bubbles
      b.paint @canvas.context
      if @pointer.current? and
      not (@pointer.bubble? and @pointer.bubble.grabbed)
        if @canvas.context.isPointInPath @pointer.current.x, @pointer.current.y
          @pointer.bubble = b

    if @pointer.bubble?
      document.body.style.cursor = "pointer"
      @pointer.bubble.popover.paint @pointer, @canvas.context

    setTimeout (=> @paint()), 1000 / @fps

  @randMax: (max) ->
    Math.floor Math.random() * max


