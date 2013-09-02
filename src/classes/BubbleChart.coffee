class @BubbleChart
  constructor: (o) ->
    @data = o.data
    @metric = o.metric
    @colors = o.colors
    @speed = o.speed || 20
    @fps = o.fps || 60
    @dragging = false

    # Calc Canvas metrics
    @canvas = document.getElementById o.canvasId
    @canvas.area = @canvas.height * @canvas.width
    @canvas.usableArea = @canvas.area * (o.usedArea || 0.5)
    @canvas.midpoint = new BubbleChart.Point(@canvas.width / 2, @canvas.height / 2)
    @canvas.context = @canvas.getContext('2d')

    # Mouse
    @mouse =
      last: null
      current: null
      bubble: null
      moving: false

    @canvas.onmousemove = do =>
      stop
      (e) =>
        clearTimeout stop
        e.offsetX ?= e.layerX
        e.offsetY ?= e.layerY
        if @mouse.current?
          @mouse.last = new BubbleChart.Point(@mouse.current.x, @mouse.current.y)
        @mouse.current = new BubbleChart.Point(e.offsetX, e.offsetY)
        @mouse.moving = true
        stop = setTimeout (=> @mouse.moving = false), 50

    @canvas.onmousedown  = (e) =>
      if @mouse.bubble?
        @mouse.bubble.grabbed = @dragging = true

    @canvas.onmouseup  = (e) =>
      if @mouse.bubble?
        @mouse.bubble.grabbed = @dragging = false

    @metricTotal = (d.data for d in @data).reduce (a, b) -> a + b

    @bubbles = []

    for d in @data
      opts =
        href: d.href
        label: d.label
        color: d.fillColor
        borderColor: d.borderColor || o.borderColor
        borderSize: d.borderSize || o.borderSize
        radius: Math.sqrt((@canvas.usableArea * (d.data / @metricTotal))) / 2
        position: new BubbleChart.Point(
          BubbleChart.randMax(Math.sqrt(@canvas.area)),
          BubbleChart.randMax(Math.sqrt(@canvas.area))
        )
        speed: @speed
        pointOfGravity: @canvas.midpoint

      @bubbles.push new BubbleChart.Bubble(opts)


  paint: ->
    for b in @bubbles
      b.advance(@)
      for bubble in @bubbles
        if b.label isnt bubble.label and b.distanceFrom(bubble) < 0
          b.resolveCollisionWith(bubble)

    @canvas.context.clearRect(0,0, @canvas.width, @canvas.height)

    document.body.style.cursor = "default" if not @dragging
    @mouse.bubble = null if not @dragging
    for b in @bubbles
      b.paint(@canvas.context)
      if @mouse.current? and not @dragging
        if @canvas.context.isPointInPath(@mouse.current.x, @mouse.current.y)
          @mouse.bubble = b

    if @mouse.bubble?
      document.body.style.cursor = "pointer"

    setTimeout (=> @paint()), 1000 / @fps

  @randMax: (max) ->
    Math.floor(Math.random() * max)


