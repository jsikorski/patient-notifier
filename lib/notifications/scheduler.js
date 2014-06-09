var Agenda = require('agenda'),
	agenda = new Agenda({db: { address: 'localhost:27017/fullstack-dev' }}),
	visitsNotifier = require('./visits-notifier'),
	Visit = require('./../models/visit');

agenda.define('remind about visit', function(job, done) {
	var visitId = job.attrs.data.visitId;
	console.log('Reminding about visit with id: ', visitId);

	Visit.findById(visitId)
		.populate('doctor')
		.populate('patient')
		.exec(function(err, visit) {
			if (err) job.fail(err.message);
			visitsNotifier.notifyAboutVisit(visit, 'visitRemainder', visit, function(err) {
				if (err) job.fail(err.message);
				done(err);
			});
		});
});

agenda.start();


module.exports = agenda;