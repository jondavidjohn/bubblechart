(function() {
	module('BubbleChart Tests');

	function generate(override_opts) {
		var opt,
			opts = {
				canvasId: 'test_canvas',
				data: [{
					label: "thing10",
					data: 10
				},{
					label: "thing5",
					data: 5
				},{
					label: "thing35",
					data:35
				},{
					label: "thing",
					data: 10
				}],
				metric: 'metric',
				colors: ['a', 'b', 'c', 'd']
			};

		for (opt in override_opts) { opts[opt] = override_opts[opt]; }
		return new BubbleChart(opts);
	}

	test('constructor', function() {
		var chart = generate();

		equal(chart.canvas.id, 'test_canvas');
		equal(chart.data.length, chart.bubbles.length);
		equal(chart.metric, 'metric');
		equal(chart.colors.length, 4);
		equal(chart.metricTotal, 60);

	});
})();
