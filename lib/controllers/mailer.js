var nodemailer = require("nodemailer"),
    mongoose = require('mongoose'),
    User = mongoose.model('User'),
    config = require('../config/config');

var sender = "patientnotifier.app@gmail.com";

var transport = nodemailer.createTransport(config.transport,
    config.transportOptions);

exports.send = function(req, res) {
    var userId = req.body.userId;
    User.findById(userId, function(err, user) {
        if (err) return res.json(400, err);
        var mailOptions = {
            from: sender,
            to: user.email,
            subject: req.body.subject,
            text: req.body.text
        };
        transport.sendMail(mailOptions, function(error, response) {
            if(error){
                console.log(error);
                return res.json(400, err);
            } else{
                console.log("Message sent: " + response.message);
                res.send(200);
            }
        });
    });
};

exports.sendMail = function(to, subject, content, isHtml, callback) {
    var mailOptions = {
        from: sender,
        to: to,
        subject: subject,
        encoding: 'utf-8'
    };

    if (isHtml) mailOptions.html = content;
    else mailOptions.text = content;

    transport.sendMail(mailOptions, callback);
};

exports.sendSms = function(number, subject, text, callback) {
    this.sendMail('+48' + number + '@text.plusgsm.pl', subject, text, false, callback);
};