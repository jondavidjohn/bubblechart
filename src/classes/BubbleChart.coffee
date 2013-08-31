class @BubbleChart
  constructor: (o) ->
    @data = o.data
    @metric = o.metric
    @colors = o.colors
    @speed = o.speed || 5
    @fps = o.fps || 30

    # Calc Canvas metrics
    @canvas = document.getElementById o.canvasId
    @canvas.usableArea = (@canvas.height * @canvas.width) * (o.usedArea || 0.5)
    @canvas.midpoint = new BubbleChart.Point(@canvas.width / 2, @canvas.height / 2)
    @canvas.context = @canvas.getContext('2d')

    @metricTotal = (d.data for d in @data).reduce (a, b) -> a + b

    @bubbles = []

    for d in @data
      x = @randMax(Math.sqrt(@canvas.usableArea))
      y = @randMax(Math.sqrt(@canvas.usableArea))

      opts =
        href: d.href
        label: d.label
        color: @colors[0]
        borderColor: @colors[0]
        radius: Math.sqrt((@canvas.usableArea * (d.data / @metricTotal))) / 2
        position: new BubbleChart.Point(x, y)
        vX: 0.05 * @randMax(@speed + 1)
        vY: 0.05 * @randMax(@speed + 1)

      @bubbles.push new BubbleChart.Bubble(opts)

    @draw()

  draw: ->
    @canvas.context.clearRect(0,0, @canvas.width, @canvas.height);
    for b in @bubbles
      b.draw(@canvas.context)
    setTimeout (=> @draw()), 1000 / @fps

  randMax: (max) ->
    Math.floor(Math.random() * max)


