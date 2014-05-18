'use strict';

var mongoose = require('mongoose'),
  User = mongoose.model('User'),
  Patient = mongoose.model('Patient');

/**
 * Populate database with sample application data
 */

// Clear old users, then add a default user
User.findOne({ email: 'user@test.com' }, function(error, user) {
  if (user) {
    console.log('test user already exists');
    return;
  }

  User.create({
    provider: 'local',
    name: 'Test User',
    email: 'user@test.com',
    password: 'user',
    role: 'user',
    active: true
  }, function() {
      console.log('finished populating test user');
    }
  );
});

User.findOne({ email: 'admin@test.com' }, function(error, admin) {
  if (admin) {
    console.log('test admin already exists');
    return;
  }

  User.create({
    provider: 'local',
    name: 'Test Admin',
    email: 'admin@test.com',
    password: 'admin',
    role: 'administrator',
    active: true
  }, function() {
      console.log('finished populating test admin');
    }
  );
});

Patient.find({}).remove(function() {
  Patient.create({
    provider: 'local',
    firstName: 'Test',
    lastName: 'Testowy',
    pesel: '49040501580',
    address: {
      zipCode: '11111',
      city: 'Test',
      street: 'Testowa'
    }
  }, function() {
    console.log('finished populating patients');
  });
});