'use strict';

var mongoose = require('mongoose'),
	Schema = mongoose.Schema,
	validation = require('./validation');

var VisitSchema = new Schema({
	start: { type: Date, required: true },
	end: { type: Date, required: true },
	doctor: { type: Schema.Types.ObjectId, required: true, ref: 'Doctor' },
	patient: { type: Schema.Types.ObjectId, required: true, ref: 'Patient' },
});

VisitSchema.path('start').validate(validation.required, 'Start date cannot be blank');
VisitSchema.path('end').validate(validation.required, 'Stop date cannot be blank');
VisitSchema.path('end').validate(function(value) {
	if (!value) return undefined;
	return value.getTime() > this.start.getTime();
}, 'End date has to be latter than start date');

VisitSchema.path('doctor').validate(validation.required, 'Doctor cannot be blank');
VisitSchema.path('patient').validate(validation.required, 'Patient cannot be blank');

var Visit = mongoose.model('Visit', VisitSchema);

VisitSchema.pre('save', function(next) {
	var that = this;
    Visit.find({doctor: this.doctor})
    	.where('_id').ne(this._id)
		.where('start').lt(this.end)
		.where('end').gt(this.start)
		.exec(function(err, visits) {
			if (err) return next(err);
			if (visits.length) {
				var error = new Error('Another visit for this doctor in this date exists.');
				error.code = 'overlapping_visit';
				return next(error);
			}
			next();
		});
  });

module.exports = Visit;