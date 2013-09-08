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
})(BubbleChart.Pointer);
