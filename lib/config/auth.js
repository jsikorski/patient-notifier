var http = require('http'), 
	req = http.IncomingMessage.prototype;

var _ = require('lodash');

var anonymousRoutes = [
	{ url: '/', method: 'GET' },
	{ url: '/login', method: 'GET' },
	{ url: '/partials/login', method: 'GET' },
	{ url: '/partials/navbar', method: 'GET' },
	{ url: '/partials/footer', method: 'GET' },
	{ url: '/partials/setPassword', method: 'GET' },
	{ url: '/api/session', method: 'POST' }
];

var activationRoute = new RegExp('\/users\/[a-z0-9]+\/activate'),
    activationMethods = [{ method:'GET' }, { method: 'PATCH' }];

req.needsAuthentication = function() {
    if(activationRoute.test(this.url) && _.find(activationMethods, { method: this.method }) !== undefined) return false;
	return _.find(anonymousRoutes, { url: this.url, method: this.method }) === undefined;
};