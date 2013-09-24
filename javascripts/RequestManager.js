function RequestManager() {
	var request_count = 0;

	this.execJSONP = function(url, callback) {
		var script = document.createElement('script'),
			randCbName = 'bc_' + Math.floor(Math.random() * 65535) + 1,
			sepChar = (url.indexOf('?') === -1) ? '?' : '&';

		script.async = true;
		request_count++;
		window[randCbName] = function(data) {
			request_count--;
			var scr = document.getElementById(randCbName);
			scr.parentNode.removeChild(scr);
			callback(data);
			window[randCbName] = null;
			delete window[randCbName];
		};

		script.src = url+sepChar+'callback='+randCbName;
		script.id = randCbName;
		document.getElementsByTagName('head')[0].appendChild(script);
	};

	this.outstandingRequests = function() {
		return request_count > 0;
	};
}
