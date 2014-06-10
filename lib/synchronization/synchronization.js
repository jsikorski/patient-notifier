'use strict';

var User = require('./../models/user'),
    calendar = require('./googleCalendar'),
    passport = require('passport'),
    GoogleStrategy = require('passport-google').Strategy;

var clientId = "365999349224-lj919pc0h6e7eejr9h4vv8bmm1ui03nq.apps.googleusercontent.com",
    clientSecret = "P9PWzJHySu42W6XdkIL9MEko",
    emailAdress = "365999349224-lj919pc0h6e7eejr9h4vv8bmm1ui03nq@developer.gserviceaccount.com";

passport.serializeUser(function(user, done) {
    done(null, user);
});

passport.deserializeUser(function(obj, done) {
    done(null, obj);
});

passport.use(new GoogleStrategy({
        clientID: clientId,
        clientSecret: clientSecret,
        returnURL: 'http://localhost:9000/users/synchronizeCallback'
    },
    function(accessToken, emailAdress, profile, done) {
        console.log('google strategy');
        process.nextTick(function () {
            console.log('Process tick');
            // To keep the example simple, the user's Google profile is returned to
            // represent the logged-in user.  In a typical application, you would want
            // to associate the Google account with a user record in your database,
            // and return that user instead.
            return done(null, profile);
        });
    }
));

exports.synchronize = function(request, response) {
    var fullUrl = request.protocol + '://' + request.get('host') + request.originalUrl;
    console.log('synchronize');
    console.log(fullUrl);
    return passport.authenticate('google', { scope: ['https://www.google.com/calendar/feeds/'] }, function(req, res){
        // The request will be redirected to Google for authentication, so this
        // function will not be called.
    })(request, response);
};


exports.synchronizeCallback = function(req, res) {
    return passport.authenticate('google', { failureRedirect: '/login' },
    function(req, res) {
        console.log('synchronizeCallback');
        res.redirect('/');
    });
};





