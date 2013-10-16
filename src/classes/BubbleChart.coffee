class @BubbleChart

  constructor: (o) ->
    @o = o
    @data = o.data or []
    @metric = o.metric
    @fillColors = o.fillColors or []
    @contain = o.contain or false
    @gutter = o.gutter or 0

    @canvas = document.getElementById o.canvasId

    o.attribution ?= 'before'
    if o.attribution
      url = 'https://github.com/jondavidjohn/bubblechart'
      a = document.createElement 'div'
      a.className = 'bubblechart-attribution'
      a.innerHTML = "<small>(Powered by <a href=\"#{url}\">BubbleChart</a>)</small>"
      if o.attribution is 'before'
        @canvas.parentNode.insertBefore a, @canvas
      if o.attribution is 'after'
        @canvas.parentNode.insertBefore a, @canvas.nextSibling

    comment = document.createComment ' BubbleChart by jondavidjohn (http://jondavidjohn.github.io/bubblechart/) '
    if @canvas.firstChild?
      @canvas.insertBefore comment, @canvas.firstChild
    else
      @canvas.appendChild comment

    # Pointer Setup
    @pointer = new BubbleChart.Pointer()

    do (c = @canvas) =>
      c.context = c.getContext '2d'

      # Adjust for retina if needed
      ratio = BubbleChart.getPixelRatio(c)
      c.style.height = "#{c.height}px"
      c.style.width = "#{c.width}px"
      c.width = c.width * ratio
      c.height = c.height * ratio

      # Attach Canvas Mouse/Touch events
      c.style.position = "relative"
      c.onmousemove = c.ontouchmove = @pointer.e_move
      c.onmousedown = c.ontouchstart = @pointer.e_grab
      c.onmouseup = c.onmouseout = c.ontouchend = @pointer.e_release
      c.style.webkitUserSelect = "none"

      # Calculate Canvas Metrics
      c.area = c.height * c.width
      c.usableArea = c.area * (o.usedArea || 0.2)
      c.midpoint = new BubbleChart.Point(c.width / 2, c.height / 2)

      @spinner = new BubbleChart.Spinner(@canvas.context)

    if @data.length
      @reload()

  @getPixelRatio: (canvas) ->
    ratio = window.devicePixelRatio or 1
    backingStoreRatio = canvas.context.webkitBackingStorePixelRatio or
                        canvas.context.mozBackingStorePixelRatio or
                        canvas.context.msBackingStorePixelRatio or
                        canvas.context.oBackingStorePixelRatio or
                        canvas.context.backingStorePixelRatio or 1
    ratio / backingStoreRatio

  reload: () ->
    @bubbles = []
    @metricTotal = (d.data for d in @data).reduce (a, b) -> a + b
    for d in @data
      randColor = do (c = @fillColors) ->
        c[Math.randInt c.length if c.length]
      opts =
        href: d.href
        label: d.label
        metric: d.metric or @o.metric
        data: d.data
        img_src: d.img_src
        img_area: d.img_area
        fillColor: d.fillColor or randColor
        borderColor: d.borderColor or @o.borderColor
        textColor: d.textColor or @o.textColor
        textFont: d.textFont or @o.textFont
        borderSize: d.borderSize or @o.borderSize
        radius: Math.sqrt(@canvas.usableArea * (d.data / @metricTotal)) / 2
        popoverOpts: @o.popoverOpts
        position: new BubbleChart.Point(
          Math.randInt(Math.sqrt(@canvas.area)),
          Math.randInt(Math.sqrt(@canvas.area))
        )
        pointOfGravity: @canvas.midpoint

      @bubbles.push new BubbleChart.Bubble(opts)
      @canvas.context.clearRect 0, 0, @canvas.width, @canvas.height

  advance: () ->
    for b in @bubbles
      b.advance @
      for bubble in @bubbles
        if b.label isnt bubble.label and b.overlapsWith(bubble)
          b.resolveCollisionWith bubble
        if @contain
          bubble.pushAwayFromEdges(@canvas, @gutter)

  paint: (_animate = true) ->
    @canvas.style.cursor = "default" unless @pointer.grabbingBubble()
    @pointer.bubble = null unless @pointer.grabbingBubble()

    # Fire non-blocking advance calculations
    # so we don't block RAF
    setTimeout (=> @advance()), 0

    for b in @bubbles
      if b.last_draw?
        b.clear @canvas.context

    for b in @bubbles
      if b.popover.last_draw?
        b.popover.clear @canvas.context

      unless @pointer.grabbingBubble()
        if @pointer.current? and @pointer.current.distance(b.position) <= b.radius
          @pointer.bubble = b

    for b in @bubbles
      b.paint @canvas.context

    if @pointer.bubble?
      @canvas.style.cursor = "pointer"
      @pointer.bubble.popover.paint @pointer, @canvas.context

    if _animate
      requestAnimationFrame (=> @paint())
