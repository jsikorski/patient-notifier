var nodemailer = require("nodemailer"),
    mongoose = require('mongoose'),
    User = mongoose.model('User');

var sender = "patientnotifier.app@gmail.com";

var smtpTransport = nodemailer.createTransport("SMTP",{
    port: 465,
    host: "smtp.gmail.com",
    secureConnection: true,
    auth: {
        user: sender,
        pass: "3?'6Xcp=T;l^ed8LXpkN"
    },
    domains: ["gmail.com", "googlemail.com"],
    requiresAuth: true
});

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
        smtpTransport.sendMail(mailOptions, function(error, response){
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