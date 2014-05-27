'use strict';

var mongoose = require('mongoose'),
  User = mongoose.model('User'),
  Patient = mongoose.model('Patient'),
  Doctor = mongoose.model('Doctor'),
  ObjectId = mongoose.Schema.Types.ObjectId;

/**
 * Populate database with sample application data
 */

// Clear old users, then add a default user
User.findOne({ email: 'user@test.com' }, function(error, user) {
  if (user) {
      if(user.related && user.related.length !== 0) {
          console.log('test user already exists');
          return;
      }
      else user.remove();
  }

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
       }, function(error, patient) {
           User.create({
                   provider: 'local',
                   name: 'Test User',
                   email: 'user@test.com',
                   password: 'user',
                   role: 'user',
                   active: true,
                   related: [patient._id]
               }, function() {
                   console.log('finished populating test user');
               }
           );
           console.log('finished populating patients');
       });
    });
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

User.findOne({ email: 'doctor@test.com' }, function(error, admin) {
    if (admin) {
        if (admin.related && admin.related.length !== 0) {
            console.log('test doctor already exists');
            return;
        }
        else admin.remove();
    }

    Doctor.find({}).remove(function() {
        Doctor.create({
            firstName: 'Doktor',
            lastName: 'Testowy',
            speciality: 'internist'
        }, function(error, doctor) {
            console.log('finished populating doctors');
            User.create({
                    provider: 'local',
                    name: 'Test Doctor',
                    email: 'doctor@test.com',
                    password: 'doctor',
                    role: 'doctor',
                    active: true,
                    related: [doctor._id]
                }, function() {
                    console.log('finished populating test doctor');
                }
            );
        });
    });
});

