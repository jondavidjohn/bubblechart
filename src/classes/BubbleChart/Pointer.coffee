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
        self.current = self.getPosition(e)
        self.moving = true
        if self.grabbingBubble()
          e.preventDefault()
          self.dragging = true
        stop = setTimeout (=> self.moving = false), 50

    @e_grab = (e) ->
      if self.bubble?
        e.preventDefault()
        self.bubble.grabbed = true
        self.diff = self.current.diff self.bubble.position
        self.current = null

    @e_release = (e) ->
      if self.grabbingBubble()
        e.preventDefault()
        self.bubble.grabbed = false
        self.diff = null
        unless self.dragging
          if window? and self.bubble.href?
            window.location.href = self.bubble.href
        self.dragging = false
      if e.type is 'mouseout'
        self.current = null

  grabbingBubble: ->
    @bubble? and @bubble.grabbed

  getPosition: do ->
    top = {}
    left = {}
    (e) ->
      element = e.target or e.srcElement
      element_id = element.id
      pr = BubbleChart.getPixelRatio(element)
      unless top[element_id]? and left[element_id]?
        top[element_id] = 0
        left[element_id] = 0
        while true
          top[element_id] += element.offsetTop or 0
          left[element_id] += element.offsetLeft or 0
          element = element.offsetParent
          break unless element
      if e.touches && e.touches.length > 0
        x = e.touches[0].pageX - left[element_id]
        y = e.touches[0].pageY - top[element_id]
      else
        x = e.pageX - left[element_id]
        y = e.pageY - top[element_id]
      new BubbleChart.Point(x * pr, y * pr)
