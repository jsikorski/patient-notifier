'use strict';

var mongoose = require('mongoose'),
	Visit = mongoose.model('Visit'),
	_ = require('lodash'),
	ObjectId = require('mongoose').Types.ObjectId,
	notifier = require('../notifications/visits-notifier'),
	moment = require('moment');


exports.index = function(req, res, next) {
	var currentUser = req.user;

	var start = req.body.start;
	var end = req.body.end;

	var doctorIds = req.body.doctorIds;
	var patientIds = req.body.patientIds;

	if (currentUser.role === 'user') {
		if (!patientIds) {
			patientIds = currentUser.related;
		} else {
			patientIds = _.intersection(patientIds, currentUser.related);
		}
	}

	if (currentUser.role === 'doctor') {
		doctorIds = currentUser.related;
	}

	var query = Visit.find({}).populate('doctor').populate('patient');
	if (start) query = query.where('start').gte(start);
	if (end) query = query.where('end').lte(end);
	if (doctorIds) query = query.where('doctor').in(doctorIds);
	if (patientIds) query = query.where('patient').in(patientIds);

	query.exec(function(err, visits) {
		if (err) return next(err);
		return res.json(visits);
	});
};

exports.create = function(req, res, next) {
	var visit = new Visit(req.body);
	visit.save(function(err, visit) {
		if (err) return res.json(400, err);
		Visit.findOne(visit).populate('doctor').populate('patient').exec(function (err, visit) {
			if (err) return next(err);
			notifier.notifyAboutVisit(visit, 'visitAdded', visit, function(err) {
				if (err) console.err('Cannot send notification for visit: ' , visit, '\nError: ', err);
				var date = new Date(moment(visit.start).subtract('hour', 1));
				req.app.agenda.schedule(date, 'remind about visit', { visitId: visit._id });
				return res.json(visit);	
			});
		});
	});
};

exports.update = function(req, res, next) {
	Visit.findById(req.params.id, function(err, visit) {
		if (err) return next(err);
		visit.start = req.body.start;
		visit.end = req.body.end;
		visit.doctor = req.body.doctor;
		visit.patient = req.body.patient;
		visit.save(function(err) {
			if (err) return res.send(400, err);
			Visit.findOne(visit)
				.populate('doctor')
				.populate('patient')
				.exec(function(err, visit) {
					if (err) return next(err);
					notifier.notifyAboutVisit(visit, 'visitUpdated', visit, function(err) {
						if (err) console.err('Cannot send notification for visit: ' , visit, '\nError: ', err);
						req.app.agenda.cancel({ 'data.visitId': visit._id }, function(err) {
							if (err) console.err('Cannot cancel remainder for visit: ' , visit, '\nError: ', err);
							var date = new Date(moment(visit.start).subtract('hour', 1));
							req.app.agenda.schedule(date, 'remind about visit', { visitId: visit._id });
							res.send(200, visit);
						});
					});
				});
		});
	});
};

exports.delete = function(req, res, next) {
	Visit.findById(req.params.id)
		.populate('doctor')
		.populate('patient')
		.exec(function(err, visit) {
			if (err) return next(err);
			if (!visit) return res.send(404);
			visit.remove(function(err) {
				if (err) return next(err);
				notifier.notifyAboutVisit(visit, 'visitDeleted', visit, function(err) {
					req.app.agenda.cancel({ 'data.visitId': visit._id }, function(err) {
						if (err) console.err('Cannot cancel remainder for visit: ' , visit, '\nError: ', err);
						res.send(200);
					});
				});
			});
		});
};