(function() {
	module('BubbleChart Patches Tests');

	test('randInt', function() {
		var test5 = Math.randInt(5),
			test3 = Math.randInt(3),
			test8 = Math.randInt(8);

		equal(true, test5 < 5);
		equal(true, test5 >= 0);
		equal(true, test3 < 3);
		equal(true, test3 >= 0);
		equal(true, test8 < 8);
		equal(true, test8 >= 0);
	});
})();
