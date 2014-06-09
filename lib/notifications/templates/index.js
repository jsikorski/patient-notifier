var jade = require('jade'),
	fs = require('fs'),
	path = require('path')
	mustache = require('mustache');


exports.plain = function(templateUri, params, callback) {
	fs.readFile(path.resolve(__dirname, templateUri), 'UTF-8', function(err, template) {
		if (err) return console.error(err);
		callback(err, mustache.render(template, params));
	});
};

exports.jade = function(templateUri, params, callback) {
	fs.readFile(path.resolve(__dirname, templateUri + '.jade'), function(err, template) {
		if (err) return console.error(err);
		template = jade.compile(template);
		callback(err, template(params));
	});
};