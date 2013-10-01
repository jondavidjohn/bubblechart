class BubbleChart.Spinner
  constructor: (@canvas) ->
    @running = false
    @lines = 12
    @start_date = null

  start: () ->
    @running = true
    @start_date = new Date()
    @paint()

  paint: () ->
    rotation = parseInt(((new Date() - @start_date) / 1000) * @lines) / @lines
    @canvas.context.save()
    @canvas.context.clearRect 0, 0, @canvas.width, @canvas.height
    @canvas.context.translate @canvas.width / 2, @canvas.height / 2
    @canvas.context.rotate Math.PI * 2 * rotation
    @canvas.context.scale 0.4, 0.4
    for i in [0...@lines]
      @canvas.context.beginPath()
      @canvas.context.rotate Math.PI * 2 / @lines
      @canvas.context.moveTo @canvas.width / 7, 0
      @canvas.context.lineTo @canvas.width / 4, 0
      @canvas.context.lineWidth = @canvas.width / 50
      @canvas.context.strokeStyle = "rgba(0,0,0," + i / @lines + ")"
      @canvas.context.stroke()
    @canvas.context.restore()

    if @running
      requestAnimationFrame((=> @paint()))
    else
      @canvas.context.clearRect 0, 0, @canvas.width, @canvas.height


  stop: () ->
    @running = false
