var notifier = require('./notifier'),
	User = require('./../models/user');


var notifications = {
	visitAdded: {
		title: 'Nowa wizyta',
		templateName: 'visit_added'
	},

	visitUpdated: {
		title: 'Wizyta została zaktualizowana',
		templateName: 'visit_updated'
	},

	visitDeleted: {
		title: 'Wizyta została odwołana',
		templateName: 'visit_deleted'
	},

	visitRemainder: {
		title: 'Przypomnienie o wizycie',
		templateName: 'visit_remainder'
	}
};


exports.notifyAboutVisit = function(visit, notificationName, params, callback) {
	var notification = notifications[notificationName];
	if (!notification) return callback(new Error('Unknown notification: ' + notificationName));

	User.find()
		.or([ { related: visit.patient }, { related: visit.doctor } ])
		.exec(function(err, users) {
			if (err) return callback(err);
			notifier.notifyUsers(users, notification, params, callback);
		});
};