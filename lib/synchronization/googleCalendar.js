'use strict';

var _ = require('lodash'),
    User = require('./../models/user'),
    gcal = require('google-calendar');


exports.createEvent = function(visit, params) {
    User.find()
        .or([ { related: visit.patient }, { related: visit.doctor } ])
        .exec(function(err, users) {
            _.each(users, function(user) {

            });
        });
};


exports.updateEvent = function(visit, params) {

};

exports.deleteEvent = function(visit, params){

};


exports.notifyAboutVisit = function(visit, params) {
};
