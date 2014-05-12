'use strict';

var mongoose = require('mongoose'),
	Patient = mongoose.model('Patient');

exports.index = function(req, res) {
	Patient.find({}, function(err, patients) {
		res.json(patients);
	});
};