class BubbleChart.Pointer
  constructor: () ->
    @current = null
    @bubble = null
    @diff = null
    @moving = false
    @dragging = false

    self = @
    @e_move = do ->
      stop = null
      (e) ->
        clearTimeout stop

        # Normalize mouse position
        e.offsetX ?= e.layerX
        e.offsetY ?= e.layerY

        self.current = new BubbleChart.Point(e.offsetX, e.offsetY)
        self.moving = true
        if self.bubble? and self.bubble.grabbed
          e.preventDefault()
          self.dragging = true
        stop = setTimeout (=> self.moving = false), 50

    @e_grab: (e) ->
      if self.bubble? and self.current?
        e.preventDefault()
        self.bubble.grabbed = true
        self.diff = self.current.diff self.bubble.position
        self.current = null

    @e_release: (e) ->
      if self.bubble?
        e.preventDefault()
        self.bubble.grabbed = false
        self.diff = null
        unless self.dragging
          if window?
            window.location.href = self.bubble.href
        self.dragging = false

