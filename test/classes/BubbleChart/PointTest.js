(function(Point) {
	module('BubbleChart.Point Tests');

	test('constructor', function() {
		var point = new Point(3, 5);

		equal(point.x, 3);
		equal(point.y, 5);
	});

	test('distance', function() {
		var point1 = new Point(3, 5),
			point2 = new Point(5, 7);

		equal(point1.distance(point2), 2.8284271247461903);
		equal(point2.distance(point1), 2.8284271247461903);
	});

	test('diff', function() {
		var point1 = new Point(3, 5),
			point2 = new Point(5, 7);

		equal(point1.diff(point2), {x: -2, y: -2});
		equal(point2.diff(point1), {x: 2, y: 2});
	});

	test('rAngle', function() {
		var point1 = new Point(3, 5),
			point2 = new Point(5, 7);

		equal(true, false);
	});

	test('angle', function() {
		var point1 = new Point(3, 5),
			point2 = new Point(5, 7);

		equal(true, false);
	});

	test('slope', function() {
		var point1 = new Point(3, 5),
			point2 = new Point(5, 7);

		equal(true, false);
	});
})(BubbleChart.Point);
