(function(Pointer) {
	module('BubbleChart.Pointer Tests');

	test('constructor', function() {
		var pointer = new Pointer();

		equal(pointer.current, null);
		equal(pointer.bubble, null);
		equal(pointer.diff, null);
		equal(pointer.moving, false);
		equal(pointer.dragging, false);
	});

	test('grabbingBubble', function() {
		var pointer = new Pointer();

		pointer.bubble = {grabbed: true};
		equal(pointer.grabbingBubble(), true);

		pointer.bubble = {grabbed: false};
		equal(pointer.grabbingBubble(), false);
	});

	test('getPixelRatio', function() {
		var pointer = new Pointer(),
			canvas = document.getElementById('test_canvas');

		canvas.context = canvas.getContext('2d');

		window.devicePixelRatio = 2;
		canvas.context.webkitBackingStorePixelRatio = 1;
		equal(BubbleChart.getPixelRatio(canvas), window.devicePixelRatio);

		window.devicePixelRatio = 2;
		canvas.context.webkitBackingStorePixelRatio = 2;
		equal(BubbleChart.getPixelRatio(canvas), 1);
	});

	test('getPosition', function() {
		var pointer = new Pointer(),
			element = document.getElementById('test_canvas'),
			canvas_top = 0,
			canvas_left = 0,
			mockEvent = null;

		window.devicePixelRatio = 1;

		function getMouseEvent() {
			var canvas = document.getElementById('test_canvas');

			canvas.context = canvas.getContext('2d');
			canvas.context.webkitBackingStorePixelRatio = 1;

			return {
				target: canvas,
				pageX: 50,
				pageY: 20
			};
		}

		function getTouchEvent() {
			var canvas = document.getElementById('test_canvas');

			canvas.context = canvas.getContext('2d');
			canvas.context.webkitBackingStorePixelRatio = 1;

			return {
				target: canvas,
				touches: [{pageX: 30, pageY: 10}]
			};
		}

		// Calculate proper offset
		do {
			canvas_top += element.offsetTop || 0;
			canvas_left += element.offsetLeft || 0;
		} while (element = element.offsetParent)

		mockEvent = getMouseEvent();
		equal(
			pointer.getPosition(mockEvent).x,
			mockEvent.pageX - canvas_left
		);

		mockEvent = getMouseEvent();
		equal(
			pointer.getPosition(mockEvent).y,
			mockEvent.pageY - canvas_top
		);

		mockEvent = getTouchEvent();
		equal(
			pointer.getPosition(mockEvent).x,
			mockEvent.touches[0].pageX - canvas_left
		);

		mockEvent = getTouchEvent();
		equal(
			pointer.getPosition(mockEvent).y,
			mockEvent.touches[0].pageY - canvas_top
		);
	});
})(BubbleChart.Pointer);
