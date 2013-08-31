class @BubbleChart
  constructor: (options) ->
    @canvas = document.getElementById options.canvasId
    @data = options.data
    @metric = options.metric
    @colors = options.colors
    @bubbles = []

