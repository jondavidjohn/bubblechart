class BubbleChart.Spinner
  constructor: (@context) ->
    @running = false
    @lines = 12
    @start_date = null

  start: () ->
    @running = true
    @start_date = new Date()
    @paint()

  paint: () ->
    rotation = parseInt(((new Date() - @start_date) / 1000) * @lines) / @lines
    @context.save()
    @context.clearRect 0, 0, @context.canvas.width, @context.canvas.height
    @context.translate @context.canvas.width / 2, @context.canvas.height / 2
    @context.rotate Math.PI * 2 * rotation
    @context.scale 0.4, 0.4
    for i in [0...@lines]
      @context.beginPath()
      @context.rotate Math.PI * 2 / @lines
      @context.moveTo @context.canvas.width / 7, 0
      @context.lineTo @context.canvas.width / 4, 0
      @context.lineWidth = @context.canvas.width / 50
      @context.strokeStyle = "rgba(0,0,0," + i / @lines + ")"
      @context.stroke()
    @context.restore()

    if @running
      requestAnimationFrame((=> @paint()))
    else
      @context.clearRect 0, 0, @context.canvas.width, @context.canvas.height

  stop: () ->
    @running = false
