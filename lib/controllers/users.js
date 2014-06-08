'use strict';

var mongoose = require('mongoose'),
    User = mongoose.model('User'),
    Patient = mongoose.model('Patient'),
    Doctor = mongoose.model('Doctor'),
    passport = require('passport');

/**
 * Create user
 */
exports.create = function (req, res, next) {
  var newUser = new User(req.body);
  newUser.provider = 'local';
  newUser.password = '12345';
  newUser.save(function(err) {
    if (err) return res.json(400, err);
    
    req.logIn(newUser, function(err) {
      if (err) return next(err);

      return res.json(req.user);
    });
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
    var userId = req.body.id;
    var newPass = String(req.body.password);
    console.log(userId);
    console.log(newPass);
    User.findById(userId, function (err, user) {
        if (!user) return res.send(404);
        if(user.newUser && !user.active) {
            user.password = newPass;
            user.newUser = false;
            user.active = true;
            user.save(function(err) {
                if (err) return res.send(400, err);
                console.log('User activated');
                res.send(200);
            });
        } else {
            res.send(403);
        }
    });
};
