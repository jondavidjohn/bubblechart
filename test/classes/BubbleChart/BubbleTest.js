(function(Bubble, Point) {
	module('BubbleChart.Bubble Tests');

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
				pointOfGravity: new Point(12, 12),
				radius: 3,
				position: new Point(3, 6)
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
		var bubble = generate({
			position: new Point(5, 10),
			pointOfGravity: new Point(15, 15)
		});

		equal(bubble.getVelocity().x, 0.4);
		equal(bubble.getVelocity().y, 0.2);

	});

	test('distanceFrom', function() {
		var bubble1 = generate({
				position: new Point(5, 10),
				radius: 5
			}),
			bubble2 = generate({
				position: new Point(20, 7),
				radius: 9
			}),
			bubble3 = generate({
				position: new Point(12, 18),
				radius: 2
			});

		equal(bubble1.distanceFrom(bubble2), -4.702941459221645);
		equal(bubble2.distanceFrom(bubble1), -4.702941459221645);
		equal(bubble2.distanceFrom(bubble3), -3.398529491264556);
		equal(bubble3.distanceFrom(bubble1), -2.36985418726535);
	});

	test('overlapsWith', function() {
		var bubble1 = generate({
				position: new Point(5, 10),
				radius: 2
			}),
			bubble2 = generate({
				position: new Point(5, 7),
				radius: 3
			}),
			bubble3 = generate({
				position: new Point(12, 18),
				radius: 2
			});

		equal(bubble1.overlapsWith(bubble2), true);
		equal(bubble2.overlapsWith(bubble1), true);
		equal(bubble2.overlapsWith(bubble3), false);
		equal(bubble3.overlapsWith(bubble1), false);
	});

	test('hasSpatialInferiorityTo', function() {
		var bubble1 = generate({
				radius: 2
			}),
			bubble2 = generate({
				radius: 3
			});

		// Bigger
		equal(true, bubble1.hasSpatialInferiorityTo(bubble2));

		// Grabbed
		bubble1.grabbed = true;
		equal(true, bubble2.hasSpatialInferiorityTo(bubble1));
		bubble1.grabbed = false;

		// Bully (been pushed by another)
		bubble2.bully = true;
		equal(true, bubble1.hasSpatialInferiorityTo(bubble2));

		// Grabbed beats bully
		bubble1.grabbed = true;
		equal(true, bubble2.hasSpatialInferiorityTo(bubble1));
	});

	test('resolveCollisionWith', function() {
		var bubble1 = generate({
				position: new Point(5, 10),
				radius: 2
			}),
			bubble2 = generate({
				position: new Point(5, 7),
				radius: 3
			});

		equal(bubble1.overlapsWith(bubble2), true);
		bubble1.resolveCollisionWith(bubble2);
		equal(bubble1.overlapsWith(bubble2), false);
	});
})(BubbleChart.Bubble, BubbleChart.Point);
