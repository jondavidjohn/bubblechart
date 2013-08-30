(function() {
	module('BubbleChart Tests');

	function generate(override_opts) {
		var opt,
			opts = {
				canvasId: 'test_canvas',
				data: [{}, {}, {}],
				metric: 'metric',
				colors: ['a', 'b', 'c', 'd']
			};

		for (opt in override_opts) { opts[opt] = override_opts[opt]; }
		return new BubbleChart(opts);
	}

	test('constructor', function() {
		var chart = generate();

		equal(chart.canvas.id, 'test_canvas');
		equal(chart.data.length, 3);
		equal(chart.metric, 'metric');
		equal(chart.colors.length, 4);
	});
})();
