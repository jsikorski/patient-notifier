var http = require('http'), 
	req = http.IncomingMessage.prototype;

var _ = require('lodash');

var anonymousRoutes = [
	{ url: '/', method: 'GET' },
	{ url: '/login', method: 'GET' },
	{ url: '/partials/login', method: 'GET' },
	{ url: '/partials/navbar', method: 'GET' },
	{ url: '/partials/footer', method: 'GET' },
	{ url: '/api/session', method: 'POST' }
];

req.needsAuthentication = function() {
	return _.find(anonymousRoutes, { url: this.url, method: this.method }) === undefined;
};