(function(Popover) {
	module('BubbleChart.Point Tests');

	function getPopover(opts) {
		var bubble = new BubbleChart.Bubble({});
		opts = opts || {};

		return new Popover(bubble, opts);
	}

	function getPointer() {
		var pointer = new BubbleChart.Pointer();
			moveEvent = {
				target: document.getElementById('test_canvas'),
				pageX: 15,
				pageY: 30,
				preventDefault: function() {}
			};

		pointer.e_move(moveEvent);
		return pointer;
	}

	test('constructor', function() {
		var popover = getPopover({
			fillColor: '#000',
			textColor: '#000',
			textFont: 'testing',
			labelSize: 3,
			metricSize: 5,
			opacity: 5,
			popoverShowData: true
		});

		equal(popover.fillColor, '#000');
		equal(popover.textColor, '#000');
		equal(popover.textFont, 'testing');
		equal(popover.labelSize, 3);
		equal(popover.metricSize, 5);
		equal(popover.opacity, 5);
		equal(popover.popoverShowData, true);
	});

	test('constructor-defaults', function() {
		var popover = getPopover();
		equal(popover.fillColor, '#333');
		equal(popover.textColor, '#FFF');
		equal(popover.textFont, 'helvetica');
		equal(popover.labelSize, 18);
		equal(popover.metricSize, 12);
		equal(popover.opacity, 0.8);
	});

	test('calculateTriangle', function() {
		var popover = getPopover();

		triangle = popover.calculateTriangle(10, 15, 1);

		equal(triangle.x, -5);
		equal(triangle.x2, 0);
		equal(triangle.x3, 5);
		equal(triangle.y, -11);
		equal(triangle.y2, 4);
		equal(triangle.y3, -11);

		// Inverted
		triangle = popover.calculateTriangle(10, -15, 1);

		equal(triangle.x, -5);
		equal(triangle.x2, 0);
		equal(triangle.x3, 5);
		equal(triangle.y, 33);
		equal(triangle.y2, 18);
		equal(triangle.y3, 33);
	});
})(BubbleChart.Popover);
