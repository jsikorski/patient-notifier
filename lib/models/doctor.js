'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    validation = require('./validation'),
    _ = require('lodash');

var requiredString = { type: String, required: true };

var DoctorSchema = new Schema({
    firstName: requiredString,
    lastName: requiredString,
    speciality: {
        type: String,
        required: true,
        default: 'internist'
    },
    color: requiredString
});

DoctorSchema.path('firstName').validate(validation.required, 'FirstName cannot be blank');
DoctorSchema.path('lastName').validate(validation.required, 'LastName cannot be blank');

module.exports = mongoose.model('Doctor', DoctorSchema);