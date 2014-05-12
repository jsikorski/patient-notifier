'use strict';

var mongoose = require('mongoose'),
		Schema = mongoose.Schema;

var PatientSchema = new Schema({
	firstName: String,
	lastName: String,
	pesel: String
});

module.exports = mongoose.model('Patient', PatientSchema);