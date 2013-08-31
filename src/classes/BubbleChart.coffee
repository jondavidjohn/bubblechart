class @BubbleChart
  constructor: (o) ->
    @data = o.data
    @metric = o.metric
    @colors = o.colors
    @speed = o.speed || 5
    @drawInterval = o.drawInterval || 1000

    # Calc Canvas metrics
    @canvas = document.getElementById o.canvasId
    @canvas.usableArea = (@canvas.height * @canvas.width) * (o.usedArea || 0.5)
    @canvas.midpoint = new BubbleChart.Point(@canvas.width / 2, @canvas.height / 2)

    @metricTotal = (d.data for d in @data).reduce (a, b) -> a + b

    @bubbles = []

    for d in @data
      x = @randMax(Math.sqrt(@canvas.usableArea))
      y = @randMax(Math.sqrt(@canvas.usableArea))

      opts =
        href: d.href
        color: ''
        borderColor: ''
        radius: Math.sqrt((@canvas.usableArea * (d.data / @metricTotal))) / 2
        position: new BubbleChart.Point(x, y)
        vX: 0.05 * @randMax(@speed + 1)
        vY: 0.05 * @randMax(@speed + 1)

      @bubbles.push new BubbleChart.Bubble(opts)

    @draw()

  draw: ->
    setTimeout (=> @draw()), @drawInterval

  randMax: (max) ->
    Math.floor(Math.random() * max)


