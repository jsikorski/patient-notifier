'use strict';

var mongoose = require('mongoose'),
	Patient = mongoose.model('Patient');

exports.index = function(req, res) {
	Patient.find({}, function(err, patients) {
		res.json(patients);
	});
};

exports.create = function(req, res) {
	var patient = new Patient(req.body);
	patient.save(function(err, patient) {
		if (err) return res.json(400, err);
		return res.json(patient);
	});
};