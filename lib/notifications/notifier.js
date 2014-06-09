var mailer = require('../controllers/mailer'),	
	_ = require('lodash'),	
	templates = require('./templates'),
	async = require('async');


var handlers = {
	email: function(user, notification, params, callback) {
		console.log('Sending email to user: ', _.pick(user, '_id', 'name', 'email'));
		templates.jade('email/' + notification.templateName, params, function(err, template) {
			if (err) return callback(err);
			mailer.sendMail(user.email, notification.title, template, true, callback);
		});
	},

	sms: function(user, notification, params, callback) {
		console.log('Sending sms to user: ', _.pick(user, '_id', 'name', 'phoneNumber'));
		templates.plain('sms/' + notification.templateName, params, function(err, template) {
			if (err) return callback(err);
			mailer.sendSms(user.phoneNumber, notification.title, template, callback);
		});
	}
};


var handleNotification = function(user, channelName, notification, params, callback) {
	var handler = handlers[channelName];
	if (!handler) return callback(new Error('Unknown notification channel: ' + channelName));
	handler(user, notification, params, callback);
};


var notifyUser = function(user, notification, params, callback) {
	var tasks = _.map(user.notificationChannels, function(channel) {
		return function(internalCallback) {
			if (channel.isActive) handleNotification(user, channel.name, notification, params, internalCallback);
			else { 
				console.warn(channel.name, 'channel is disabled for user: ', _.pick(user, '_id', 'name', 'email'));
				internalCallback(null); 
			}
		};
	});

	async.parallel(tasks, callback);
};


var notifyUsers = function(users, notification, params, callback) {
	var tasks = _.map(users, function(user) {
		return function(internalCallback) { 
			notifyUser(user, notification, params, internalCallback); 
		};
	});

	async.parallel(tasks, callback);
};


exports.notifyUser = notifyUser;
exports.notifyUsers = notifyUsers;