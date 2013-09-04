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
    @colors = o.colors || []
    @fps = o.fps || 60

    # Calc Canvas metrics
    @canvas = document.getElementById o.canvasId
    @canvas.area = @canvas.height * @canvas.width
    @canvas.usableArea = @canvas.area * (o.usedArea || 0.5)
    @canvas.midpoint = new BubbleChart.Point(@canvas.width/2, @canvas.height/2)
    @canvas.context = @canvas.getContext('2d')

    # pointer
    @pointer =
      current: null
      bubble: null
      diff: null
      moving: false
      dragging: false

    @canvas.onmousemove = @canvas.ontouchmove = do =>
      stop = null
      (e) =>
        clearTimeout stop
        e.offsetX ?= e.layerX
        e.offsetY ?= e.layerY
        @pointer.current = new BubbleChart.Point(e.offsetX, e.offsetY)
        @pointer.moving = true
        if @pointer.bubble? and @pointer.bubble.grabbed
          e.preventDefault()
          @pointer.dragging = true
        stop = setTimeout (=> @pointer.moving = false), 50

    @canvas.onmousedown = @canvas.ontouchstart = (e) =>
      if @pointer.bubble?
        e.preventDefault()
        @pointer.bubble.grabbed = true
        @pointer.diff = @pointer.current.diff(@pointer.bubble.position)
        @pointer.current = null

    @canvas.onmouseup = @canvas.onmouseout = @canvas.ontouchend = (e) =>
      if @pointer.bubble?
        e.preventDefault()
        @pointer.bubble.grabbed = false
        @pointer.diff = null
        unless @pointer.dragging
          console.log "No Drag, just click-ish"
        @pointer.dragging = false

    @metricTotal = (d.data for d in @data).reduce (a, b) -> a + b

    @bubbles = []

    for d in @data
      opts =
        href: d.href
        label: d.label
        metric: d.metric || o.metric
        data: d.data
        color: d.fillColor
        borderColor: d.borderColor || o.borderColor
        textColor: d.textColor || o.textColor
        borderSize: d.borderSize || o.borderSize
        radius: Math.sqrt((@canvas.usableArea * (d.data / @metricTotal))) / 2
        position: new BubbleChart.Point(
          BubbleChart.randMax(Math.sqrt(@canvas.area)),
          BubbleChart.randMax(Math.sqrt(@canvas.area))
        )
        pointOfGravity: @canvas.midpoint

      @bubbles.push new BubbleChart.Bubble(opts)


  paint: ->
    for b in @bubbles
      b.advance(@)
      for bubble in @bubbles
        if b.label isnt bubble.label and b.distanceFrom(bubble) < 0
          b.resolveCollisionWith(bubble)

    @canvas.context.clearRect(0,0, @canvas.width, @canvas.height)

    if @pointer.bubble?
      document.body.style.cursor = "default" unless @pointer.bubble.grabbed
      @pointer.bubble = null unless @pointer.bubble.grabbed

    for b in @bubbles
      b.paint(@canvas.context)
      if @pointer.current? and
      not (@pointer.bubble? and @pointer.bubble.grabbed)
        if @canvas.context.isPointInPath(@pointer.current.x, @pointer.current.y)
          @pointer.bubble = b

    if @pointer.bubble?
      document.body.style.cursor = "pointer"
      @pointer.bubble.popover.paint(@pointer, @canvas.context)

    setTimeout (=> @paint()), 1000 / @fps

  @randMax: (max) ->
    Math.floor(Math.random() * max)


