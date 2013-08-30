(function() {
	module('BubbleChart.Bubble Tests');

	function generate(override_opts) {
		var opt,
			opts = {
				href: 'http://example.com',
				color: 'red',
				borderColor: 'white',
				radius: 3,
				x: 3,
				y: 6
			};

		for (opt in override_opts) { opts[opt] = override_opts[opt]; }
		return new BubbleChart.Bubble(opts);
	}

	test('constructor', function() {
		var bubble = generate();

		equal(bubble.grabbed, false);
		equal(bubble.href, 'http://example.com');
		equal(bubble.color, 'red');
		equal(bubble.borderColor, 'white');
		equal(bubble.radius, 3);
		equal(bubble.position.x, 3);
		equal(bubble.position.y, 6);
		equal(bubble.velocity.x, 0);
		equal(bubble.velocity.y, 0);
	});

	test('updateVelocity', function() {
		var bubble = generate();

		bubble.updateVelocity(2, 5);

		equal(bubble.velocity.x, 2);
		equal(bubble.velocity.y, 5);
	});
})();
