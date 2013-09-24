(function() {
	var chart = new BubbleChart({
			canvasId: "congress-canvas",
			metric: "% - Non-votes",
			usedArea: 0.35,
			contain: true,
			attribution: false,
			popoverOpts: {
				textFont: "Raleway",
			}
		}),
		rm = new RequestManager(),
		jsonp_cb = null,
		nonvote_data = {},
		totalvote_data = {},
		chart_data = [];

	function construct_url(endpoint, params) {
		var base_url = 'http://congress.api.sunlightfoundation.com/',
			apikey = congress_key,
			params_qs = [];

		params = params || {};
		params.apikey = apikey;

		for (var param in params) {
			if (params.hasOwnProperty(param)) {
				params_qs.push(param + '=' + params[param]);
			}
		}

		return base_url + endpoint + '?' + params_qs.join('&');
	}

	function format_chart_data(bioguide_id, stat) {
		var leg;
		if (legislators.hasOwnProperty(bioguide_id) && legislators[bioguide_id].in_office === "1") {
			leg = legislators[bioguide_id];
			return {
				label: leg.title + '. ' + leg.firstname + ' ' + leg.lastname + ' (' + leg.party + '-' + leg.state + ')',
				data: stat,
				fillColor: getPartyColor(leg.party),
				href: leg.congresspedia_url
			};
		}
	}

	jsonp_cb = function(res) {
		var i, id, len, stat;

		for (i = 0, len = res.results.length; i < len; i++) {
			for (id in res.results[i].voter_ids) {
				if (res.results[i].voter_ids.hasOwnProperty(id)) {
					if (["Not Voting", "Present"].indexOf(res.results[i].voter_ids[id]) !== -1) {
						if (nonvote_data.hasOwnProperty(id)) {
							nonvote_data[id]++;
						}
						else {
							nonvote_data[id] = 1;
						}
					}

					if (totalvote_data.hasOwnProperty(id)) {
						totalvote_data[id]++;
					}
					else {
						totalvote_data[id] = 1;
					}
				}
			}
		}

		if (!rm.outstandingRequests()) {
			for (id in nonvote_data) {
				if (nonvote_data.hasOwnProperty(id)) {
					stat = Math.round((nonvote_data[id] / totalvote_data[id]) * 100);
					if (stat > 15) {
						chart_data.push(format_chart_data(id, stat));
					}
				}
			}

			chart_data = chart_data.filter(function(a) { return !!a; });

			chart.data = chart_data;
			chart.reload();
			chart.paint();
		}
	};

	// Initial request to get pagination info
	rm.execJSONP(
		construct_url('votes', {
			year: 2013,
			fields: 'voter_ids,roll_id',
			per_page: 50,
			page: 1
		}),
		function(res) {
			var pages = Math.floor(res.count / 50) + 1;

			for (var i = 2; i <= pages; i++) {
				rm.execJSONP(
					construct_url('votes', {
						year: 2013,
						fields: 'voter_ids,roll_id',
						per_page: 50,
						page: i
					}),
					jsonp_cb
				);
			}

			jsonp_cb(res); // Process page 1
		}
	);

	function getLegislator(bioguide_id) {
	}

	function getPartyColor(party) {
		switch(party) {
			case 'R':
				return '#861316';

			case 'D':
				return '#033A76';

			default:
				return '#bbb';
		}
	}
}).call();
