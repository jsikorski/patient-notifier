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

exports.update = function(req, res, next) {
	var patient = new Patient(req.body);
	patient.validate(function(err) {
		if (err) return res.json(400, err);

		Patient.findByIdAndUpdate(req.params.id, req.body, function(err, patient) {
			if (err) return res.json(400, err);
			if (!patient) return res.send(404);
			res.json(patient);
		});
	});
};