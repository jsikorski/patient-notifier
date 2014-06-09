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
	}
};


exports.notifyAboutVisit = function(visit, notificationName, params) {
	var notification = notifications[notificationName];
	if (!notification) return console.error('Unknown notification: ', notificationName);

	User.find()
		.or([ { related: visit.patient }, { related: visit.doctor } ])
		.exec(function(err, users) {
			notifier.notifyUsers(users, notification, params);
		});
};