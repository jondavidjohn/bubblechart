module('BubbleChart.Bubble Tests');

(function(Bubble) {

	function generate(override_opts) {
		var opt,
			opts = {
				href: 'http://example.com',
				fillColor: 'red',
				label: 'label',
				textColor: 'textcolor',
				textType: 'font',
				borderColor: 'white',
				borderSize: 3,
				radius: 3,
				position: {
					x: 3,
					y: 6
				}
			};

		for (opt in override_opts) { opts[opt] = override_opts[opt]; }
		return new Bubble(opts);
	}

	test('constructor', function() {
		var bubble = generate();

		equal(bubble.grabbed, false);
		equal(bubble.href, 'http://example.com');
		equal(bubble.fillColor, 'red');
		equal(bubble.borderColor, 'white');
		equal(bubble.radius, 3);
		equal(bubble.position.x, 3);
		equal(bubble.position.y, 6);
	});

	test('velocity', function() {
		var bubble = generate();

		equal(true, false);
	});

	test('distanceFrom', function() {
		var bubble = generate();

		equal(true, false);
	});

	test('overlapsWith', function() {
		var bubble = generate();

		equal(true, false);
	});

	test('resolveCollisionWith', function() {
		var bubble = generate();

		equal(true, false);
	});
})(BubbleChart.Bubble);
