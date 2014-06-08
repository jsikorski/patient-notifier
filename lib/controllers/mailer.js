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

exports.sendMail = function(to, subject, text, res) {
    var mailOptions = {
        from: sender,
        to: to,
        subject: subject,
            text: text
    };
    transport.sendMail(mailOptions, function(error, response) {
        if(error) {
            console.log(error);
        } else {
            console.log("Message sent: " + response.message);
        }
    res();
    });
};