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
		equal(pointer.getPixelRatio(canvas), window.devicePixelRatio);

		window.devicePixelRatio = 2;
		canvas.context.webkitBackingStorePixelRatio = 2;
		equal(pointer.getPixelRatio(canvas), 1);
	});

	test('getPosition', function() {
		var pointer = new Pointer(),
			canvas = document.getElementById('test_canvas');
		canvas.context = canvas.getContext('2d');
		canvas.context.webkitBackingStorePixelRatio = 1;
		window.devicePixelRatio = 1;

		canvas.getBoundingClientRect = function() {
			return { left: 10, top: 20 };
		};

		// Mock Event Object
		mockEvent = {
			target: canvas,
			pageX: 50,
			pageY: 20
		};

		boundingRect = canvas.getBoundingClientRect();

		equal(
			pointer.getPosition(mockEvent).x,
			mockEvent.pageX - boundingRect.left
		);
		equal(
			pointer.getPosition(mockEvent).y,
			mockEvent.pageY - boundingRect.top
		);

		// Set up for touch detection
		mockEvent.touches = [{pageX: 30, pageY: 10}];

		equal(
			pointer.getPosition(mockEvent).x,
			mockEvent.touches[0].pageX - boundingRect.left
		);
		equal(
			pointer.getPosition(mockEvent).y,
			mockEvent.touches[0].pageY - boundingRect.top
		);
	});
})(BubbleChart.Pointer);
