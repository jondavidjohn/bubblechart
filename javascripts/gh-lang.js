(function() {
	var chart = new BubbleChart({
			canvasId: "gh-lang-canvas",
			metric: "Kb",
			usedArea: 0.35,
			contain: true,
			attribution: false,
			popoverOpts: {
				textFont: "Raleway",
			}
		}),
		lang_data = {},
		rm = new RequestManager(),
		timer;

	function _url(endpoint, params) {
		var base_url = 'https://api.github.com/',
			access_token = gh_key,
			params_qs = [];

		params = params || {};
		params.access_token = access_token;

		for (var param in params) {
			params_qs.push(param + '=' + params[param]);
		}

		if (endpoint.substring(0,4) == 'http') {
			return endpoint + '?' + params_qs.join('&');
		}
		else {
			return base_url + endpoint + '?' + params_qs.join('&');
		}
	}

	document.getElementById('gh-lang-username-btn').onclick = function(e) {
		var input = document.getElementById('gh-lang-username'),
			button = e.target || e.srcElement,
			username = input.value;

		input.disabled = true;
		button.disabled = true;
		button.className = button.className += ' disabled';

		rm.execJSONP(
			_url('users/'+username+'/repos'),
			function(response) {
				if (response.meta.status !== 200) {
					alert(response.data.message);
					return;
				}

				for (var i = 0, len = response.data.length; i < len; i++) {
					if (response.data[i].fork) continue;

					(function(repo) {
						var lang_cb;

						lang_cb = function(lang_response) {
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
						rm.execJSONP(_url(repo.languages_url), lang_cb);
					})(response.data[i]);
				}
			}
		);

		setTimeout(function(){
			timer = setInterval(function() {
				if (rm.outstandingRequests()) return;

				clearInterval(timer);

				chart.data = [];

				for (var lang in lang_data) {
					(function(lang, bytes) {
						chart.data.push({
							label: lang,
							data: Math.round(bytes / 1024), // kb
							fillColor: langColor(lang)
						});
					})(lang, lang_data[lang]);
				}

				if (chart.data.length) {
					chart.reload();
					chart.paint();
				}

				lang_data = {};
				input.disabled = false;
				button.disabled = false;
				button.className = button.className.replace('disabled', '');
			}, 1000);
		}, 500);
	};

	function langColor(lang) {
		var colors = {
			"Arduino": "#bd79d1",
			"Java": "#b07219",
			"VHDL": "#543978",
			"Scala": "#7dd3b0",
			"Emacs Lisp": "#c065db",
			"Delphi": "#b0ce4e",
			"Ada": "#02f88c",
			"VimL": "#199c4b",
			"Perl": "#0298c3",
			"Lua": "#fa1fa1",
			"Rebol": "#358a5b",
			"Verilog": "#848bf3",
			"Factor": "#636746",
			"Ioke": "#078193",
			"R": "#198ce7",
			"Erlang": "#949e0e",
			"Nu": "#c9df40",
			"AutoHotkey": "#6594b9",
			"Clojure": "#db5855",
			"Shell": "#5861ce",
			"Assembly": "#a67219",
			"Parrot": "#f3ca0a",
			"Turing": "#45f715",
			"AppleScript": "#3581ba",
			"Eiffel": "#946d57",
			"Common Lisp": "#3fb68b",
			"Dart": "#cccccc",
			"SuperCollider": "#46390b",
			"CoffeeScript": "#244776",
			"XQuery": "#2700e2",
			"Haskell": "#29b544",
			"Racket": "#ae17ff",
			"Elixir": "#6e4a7e",
			"HaXe": "#346d51",
			"Ruby": "#701516",
			"Self": "#0579aa",
			"Fantom": "#dbded5",
			"Groovy": "#e69f56",
			"C": "#555",
			"JavaScript": "#f15501",
			"D": "#fcd46d",
			"ooc": "#b0b77e",
			"C++": "#f34b7d",
			"Dylan": "#3ebc27",
			"Nimrod": "#37775b",
			"Standard ML": "#dc566d",
			"Objective-C": "#f15501",
			"Nemerle": "#0d3c6e",
			"Mirah": "#c7a938",
			"Boo": "#d4bec1",
			"Objective-J": "#ff0c5a",
			"Rust": "#dea584",
			"Prolog": "#74283c",
			"Ecl": "#8a1267",
			"Gosu": "#82937f",
			"FORTRAN": "#4d41b1",
			"ColdFusion": "#ed2cd6",
			"OCaml": "#3be133",
			"Fancy": "#7b9db4",
			"Pure Data": "#f15501",
			"Python": "#3581ba",
			"Tcl": "#e4cc98",
			"Arc": "#ca2afe",
			"Puppet": "#cc5555",
			"Io": "#a9188d",
			"Max": "#ce279c",
			"Go": "#8d04eb",
			"ASP": "#6a40fd",
			"Visual Basic": "#945db7",
			"PHP": "#6e03c1",
			"Scheme": "#1e4aec",
			"Vala": "#3581ba",
			"Smalltalk": "#596706",
			"Matlab": "#bb92ac",
			"C#": "#bb92af"
		};
		return colors[lang];
	}
}).call();
