(function() {
	var chart = new BubbleChart({
			canvasId: "gh-lang-canvas",
			metric: "Kb",
			usedArea: 0.35,
			contain: true,
			popoverOpts: {
				textFont: "Raleway",
			}
		}),
		lang_data = {},
		timer,
		username = 'jondavidjohn';

	BCExamples.execJSONP('https://api.github.com/users/'+username+'/repos', function(response) {
		if (response.meta.status !== 200) {
			alert(response.data.message);
			return;
		}

		for (var i = 0, len = response.data.length; i < len; i++) {
			if (response.data[i].fork) continue;

			(function(repo) {
				var lang_cb;

				lang_cb = function self(lang_response) {
					for (var lang in lang_response.data) {
						(function(lang, bytes) {
							if (!lang_data.hasOwnProperty(lang)) {
								lang_data[lang] = 0;
							}
							lang_data[lang] += bytes;
						})(lang, lang_response.data[lang]);
					}
				};
				lang_cb.repo = repo.name;
				BCExamples.execJSONP(repo.languages_url, lang_cb);
			})(response.data[i]);
		}
	});

	setTimeout(function(){
		timer = setInterval(function() {
			if (BCExamples.outstandingRequests()) return;

			clearInterval(timer);

			console.log(lang_data);
			for (var lang in lang_data) {
				(function(lang, bytes) {
					chart.data.push({
						label: lang,
						data: bytes,
						fillColor: BCExamples.getLangColor(lang)
					});
				})(lang, lang_data[lang]);
			}

			chart.reload();
			chart.paint();
		}, 1000);
	}, 1000);
}).call();
