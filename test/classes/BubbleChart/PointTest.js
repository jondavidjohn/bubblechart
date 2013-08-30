(function() {
	module('BubbleChart.Point Tests');

	test('constructor', function() {
		var point = new BubbleChart.Point(3, 5);

		equal(point.x, 3);
		equal(point.y, 5);
	});

	test('distanceBetween', function() {
		var point1 = new BubbleChart.Point(3, 5),
			point2 = new BubbleChart.Point(5, 7);

		equal(point1.distanceBetween(point2), 2.8284271247461903);
		equal(point2.distanceBetween(point1), 2.8284271247461903);
	});
})();
