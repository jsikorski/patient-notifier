var mailer = require('../controllers/mailer'),	
	_ = require('lodash'),	
	templates = require('./templates');


var handlers = {
	email: function(user, notification, params) {
		console.log('Sending email to user: ', _.pick(user, '_id', 'name', 'email'));
		templates.jade('email/' + notification.templateName, params, function(err, template) {
			mailer.sendMail(user.email, notification.title, template, true);
		});
	},

	sms: function(user, notification, params) {
		console.log('Sending sms to user: ', _.pick(user, '_id', 'name', 'phoneNumber'));
		templates.plain('sms/' + notification.templateName, params, function(err, template) {
			mailer.sendSms(user.phoneNumber, notification.title, template);
		});
	}
};


var handleNotification = function(user, channelName, notification, params) {
	var handler = handlers[channelName];
	if (!handler) return console.error('Unknown notification channel: ', channelName);
	handler(user, notification, params);};


var notifyUser = function(user, notification, params) {
	_.each(user.notificationChannels, function(channel) {
		if (channel.isActive) handleNotification(user, channel.name, notification, params);
	});
};


var notifyUsers = function(users, notification, params) {
	_.each(users, function(user) {
		notifyUser(user, notification, params);
	});
};


exports.notifyUser = notifyUser;exports.notifyUsers = notifyUsers;