'use strict';

var _ = require('lodash'),
    User = require('./../models/user'),
    googleapis = require('googleapis');

var clientId = "365999349224-lj919pc0h6e7eejr9h4vv8bmm1ui03nq.apps.googleusercontent.com",
    clientSecret = "P9PWzJHySu42W6XdkIL9MEko",
    emailAdress = "365999349224-lj919pc0h6e7eejr9h4vv8bmm1ui03nq@developer.gserviceaccount.com";


exports.createEvent = function(visit, params) {
    User.find()
        .or([ { related: visit.patient }, { related: visit.doctor } ])
        .exec(function(err, users) {
            _.each(users, function(user) {
                if(user.isGmailUser()) {

                }
            });
        });
};


exports.updateEvent = function(visit, params) {

};

exports.deleteEvent = function(visit, params){

};


exports.notifyAboutVisit = function(visit, params) {
};
