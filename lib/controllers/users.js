'use strict';

var mongoose = require('mongoose'),
    User = mongoose.model('User'),
    Patient = mongoose.model('Patient'),
    Doctor = mongoose.model('Doctor'),
    passport = require('passport'),
    mailer = require('./mailer'),
    _ = require('lodash');

/**
 * Create user
 */
exports.create = function (req, res, next) {
    var newUser = new User(req.body);
    newUser.provider = 'local';
    newUser.password = '12345';
    newUser.save(function(err) {
        if (err) return res.json(400, err);
        var url = req.protocol + '://' + req.get('host');
        var activationLink = url + "/users/" + newUser._id + "/activate";
        mailer.sendMail(newUser.email, 'Account activation', activationLink, false);
        return res.json(newUser);
    });
};

/**
 *  Get profile of specified user
 */
exports.show = function (req, res, next) {
    var userId = req.params.id;

    User.findById(userId, function (err, user) {
        if (err) return next(err);
        if (!user) return res.send(404);

        res.send({ profile: user.profile });
  });
};

/**
 * Change password
 */
exports.changePassword = function(req, res, next) {
    var userId = req.user._id;
    var oldPass = String(req.body.oldPassword);
    var newPass = String(req.body.newPassword);

    User.findById(userId, function (err, user) {
        if(user.authenticate(oldPass)) {
            user.password = newPass;
            user.save(function(err) {
                if (err) return res.send(400);

                res.send(200);
                });
        } else {
            res.send(403);
        }
    });
};

/**
 * Get current user
 */
exports.me = function(req, res) {
    res.json(req.user || null);
};

exports.index = function(req, res) {
    User.find({}, function(err, users) {
        res.json(users);
    });
};

exports.update = function(req, res, next) {
    var user = new User(req.body);
    user.validate(function(err) {
        if (err) return res.json(400, err);

        User.findByIdAndUpdate(req.params.id, req.body, function(err, user) {
            if (err) return res.json(400, err);
            if (!user) return res.send(404);
            res.json(user);
        });
    });
};

/**
 *  Get profile of specified user
 */
exports.showRelated = function (req, res, next) {
    var userId = req.params.id;
    User.findById(userId, function (err, user) {
        if (err) return next(err);
        if (!user) return res.send(404);
        Patient.find({'_id': {$in: user.related }}, function(error, patients) {
            if (error) return next(error);
            Doctor.find({'_id': {$in: user.related }}, function(error, doctors) {
                if (error) return next(error);
                return res.send({patients: patients, doctors: doctors});
            });
        });
    });
};


/**
 *  Get profile of specified user
 */
exports.get = function (req, res, next) {
    var userId = req.params.id;

    User.findById(userId, function (err, user) {
        if (err) return next(err);
        if (!user) return res.send(404);

        res.json(user);
    });
};

exports.activate = function(req, res, next) {
    var userId = req.params.id;
    var newPass = String(req.body.password);
    User.findById(userId, function (err, user) {
        if (err) return next(err);
        if (!user) return res.send(404);
        if(user.newUser && !user.active) {
            user.password = newPass;
            user.newUser = false;
            user.active = true;
            user.save(function(err) {
                if (err) return res.send(400, err);
                res.send(200);
            });
        } else {
            res.send(403);
        }
    });
};

exports.updateNotificationChannels = function (req, res, next) {
    var userId = req.params.id;
    var notificationChannels = req.body.notificationChannels;
    if (!notificationChannels) return res.send(400);

    User.findById(userId, function(err, user) {
      if (err) return next(err);
      if (!user) return res.send(404);
      user.notificationChannels = notificationChannels;
      user.save(function(err) {
        if (err) return next(err);
        res.send(notificationChannels);
      });
    });
};

exports.synchronize = function(req, res, next) {
    var userId = req.params.id;

    User.findById(userId, function(err, user) {
        if (err) return next(err);
        if (!user) return res.send(404);
        user.save(function(err) {
            if (err) return next(err);
        });
    });
};


exports.addAttachment = function(req, res, next) {
    var userId = req.params.id;

    User.findById(userId, function(err, user) {
        if (err) return next(err);
        if (!user) return res.send(404);
        
        _.each(req.files, function(file) {
            user.attachments.push({
                name: file.originalname,
                path: file.name,
                mimetype: file.mimetype
            });
        });

        user.save(function(err) {
            if (err) return next(err);
            return res.send(201);
        });
    });
};