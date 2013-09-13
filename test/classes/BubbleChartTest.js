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
				fillColors: ['a', 'b', 'c', 'd']
			};

		for (opt in override_opts) { opts[opt] = override_opts[opt]; }
		return new BubbleChart(opts);
	}

	test('constructor', function() {
		var chart = generate();
		equal(chart.canvas.id, 'test_canvas');
		equal(chart.data.length, chart.bubbles.length);
		equal(chart.metric, 'metric');
		equal(chart.fillColors.length, 4);
		equal(chart.metricTotal, 60);
	});

	test('attribution-before-default', function() {
		var chart = generate();
		notStrictEqual(chart.canvas.previousSibling.innerHTML.indexOf('https://github.com/jondavidjohn/bubblechart'), -1);
	});
	test('attribution-before', function() {
		var chart = generate({ attribution: 'before' });
		notStrictEqual(chart.canvas.previousSibling.innerHTML.indexOf('https://github.com/jondavidjohn/bubblechart'), -1);
	});
	test('attribution-after', function() {
		var chart = generate({ attribution: 'after' });
		notStrictEqual(chart.canvas.nextSibling.innerHTML.indexOf('https://github.com/jondavidjohn/bubblechart'), -1);
	});
	test('attribution-off', function() {
		var chart = generate({ attribution: false }),
			prev_sibling = chart.canvas.previousSibling,
			next_sibling = chart.canvas.nextSibling,
			assertions = 0;



		if ('innerHTML' in next_sibling) {
			assertions++;
			equal(next_sibling.innerHTML.indexOf('https://github.com/jondavidjohn/bubblechart'), -1);
		}

		if ('innerHTML' in prev_sibling) {
			assertions++;
			equal(prev_sibling.innerHTML.indexOf('https://github.com/jondavidjohn/bubblechart'), -1);
		}

		expect(assertions);
	});
})();
