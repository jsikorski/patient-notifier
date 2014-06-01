'use strict';

var mongoose = require('mongoose'),
    Doctor = mongoose.model('Doctor'),
    RColor = require('../vendor/rcolor')(),
    rColor = new RColor();

exports.index = function(req, res) {
    Doctor.find({}, function(err, doctors) {
        res.json(doctors);
    });
};

exports.create = function(req, res) {
    var doctor = new Doctor(req.body);
    doctor.color = rColor.get(true, 0.3, 0.7);
    doctor.save(function(err, doctor) {
        if (err) return res.json(400, err);
        return res.json(doctor);
    });
};

exports.update = function(req, res, next) {
    var doctor = new Doctor(req.body);
    doctor.validate(function(err) {
        if (err) return res.json(400, err);

        Doctor.findByIdAndUpdate(req.params.id, req.body, function(err, doctor) {
            if (err) return res.json(400, err);
            if (!doctor) return res.send(404);
            res.json(doctor);
        });
    });
};