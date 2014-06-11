'use strict';

var mongoose = require('mongoose'),
	Patient = mongoose.model('Patient'),
	_ = require('lodash');


var index = function(req, res) {
	Patient.find({}, function(err, patients) {
		if (err) return res;
		res.json(patients);
	});
};

exports.index = index;

exports.create = function(req, res) {
	var patient = new Patient(req.body);
	patient.save(function(err, patient) {
		if (err) return res.json(400, err);
		return res.json(patient);
	});
};

exports.update = function(req, res, next) {
	Patient.findById(req.params.id, function(err, patient) {
		if (err) return res.json(404, err);
		_.extend(patient, req.body);
		patient.save(function(err) {
			if (err) return res.json(400, err);
			res.json(patient);
		});
	});
};

exports.search = function(req, res, next) {
	if (!req.query.term) return index(req, res, next);

	Patient.search({
		type: 'patient',
		query: {
			multi_match: {
				query: req.query.term,
				fuzziness: 0.5,
				fields: [ 'firstName', 'lastName', 'pesel', 'address.zipCode', 'address.city', 'address.street' ]
			}
		}
	}, function(err, results) {
		if (err) return next(err);
		return res.send(_.map(results.hits.hits, function(hit) {
			return _.extend(hit._source, { _id: hit._id });
		}));
	});
};