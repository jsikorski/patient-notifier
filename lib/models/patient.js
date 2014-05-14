'use strict';

var mongoose = require('mongoose'),
		Schema = mongoose.Schema,
		validation = require('./validation'),
		_ = require('lodash');

var PatientSchema = new Schema({
	firstName: String,
	lastName: String,
	pesel: String
});

PatientSchema.path('firstName').validate(validation.required, 'FirstName cannot be blank');
PatientSchema.path('lastName').validate(validation.required, 'FirstName cannot be blank');
PatientSchema.path('pesel').validate(validation.required, 'FirstName cannot be blank');

PatientSchema.path('pesel').validate(function(value) {
	var hasValidFormat = new RegExp(/^\d{11}$/).test(value);
	var digits = _.map(value, function(digit) { return parseInt(digit, 10); });
	var hasValidChecksum = 
		(digits[0] + 3 * digits[1] + 7 * digits[2] + 
		9 * digits[3] + digits[4] + 3 * digits[5] + 
		7 * digits[6] + 9 * digits[7] + digits[8] + 
		3 * digits[9] + digits[10]) % 10 === 0;

	return hasValidFormat && hasValidChecksum;
}, 'Pesel format is invalid');


module.exports = mongoose.model('Patient', PatientSchema);