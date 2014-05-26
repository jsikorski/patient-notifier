'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    validation = require('./validation'),
    _ = require('lodash');

var DoctorSchema = new Schema({
    firstName: String,
    lastName: String,
    speciality: String
});

DoctorSchema.path('firstName').validate(validation.required, 'FirstName cannot be blank');
DoctorSchema.path('lastName').validate(validation.required, 'LastName cannot be blank');

module.exports = mongoose.model('Doctor', DoctorSchema);