var nodemailer = require("nodemailer");

var sender = "patientnotifier.app@gmail.com";

var smtpTransport = nodemailer.createTransport("SMTP",{
    service: "Gmail",
    auth: {
        user: sender,
        pass: "3?'6Xcp=T;l^ed8LXpkN"
    }
});

function sendMail(mailOptions) {
    smtpTransport.sendMail(mailOptions, function (error, response) {
        if (error) {
            console.log(error);
        } else {
            console.log("Message sent: " + response.message);
        }
    });
}

exports.sendActivationMail = function(receiver, activationLink) {
    var mailOptions = {
        from: sender, // sender address
        to: receiver, // list of receivers
        subject: 'PatientNotifier account activation',
        text: activationLink
    };

    sendMail(mailOptions);
};

sendMail();