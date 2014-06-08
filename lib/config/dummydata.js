'use strict';

var mongoose = require('mongoose'),
  User = mongoose.model('User'),
  Patient = mongoose.model('Patient'),
  Doctor = mongoose.model('Doctor');

/**
 * Populate database with sample application data
 */

// Clear old users, then add a default user
User.findOne({ email: 'user@test.com' }, function(err, user) {
  if (err) return console.log(err);

  if (user) {
      if(user.related && user.related.length !== 0) {
          console.log('test user already exists');
          return;
      }
      else user.remove();
  }

   Patient.find({}).remove(function(err) {
      if (err) return console.log(err);

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
       }, function(err, patient) {
          if (err) return console.log(err);
          User.create({
                   provider: 'local',
                   name: 'Test User',
                   email: 'user@test.com',
                   phoneNumber: '111222333',
                   password: 'user',
                   role: 'user',
                   active: true,
                   related: [patient._id]
               }, function(err) {
                  if (err) return console.log(err);
                  console.log('finished populating test user');
               }
           );
           console.log('finished populating patients');
       });
    });
});

User.findOne({ email: 'admin@test.com' }, function(err, admin) {
  if (err) return console.log(err);

  if (admin) {
    console.log('test admin already exists');
    return;
  }

  User.create({
    provider: 'local',
    name: 'Test Admin',
    email: 'admin@test.com',
    phoneNumber: '444555666',
    password: 'admin',
    role: 'administrator',
    active: true
  }, function(err) {
      if (err) return console.log(err);
      console.log('finished populating test admin');
    }
  );
});

User.findOne({ email: 'doctor@test.com' }, function(err, admin) {
    if (err) return console.log(err);
    if (admin) {
        if (admin.related && admin.related.length !== 0) {
            console.log('test doctor already exists');
            return;
        }
        else admin.remove();
    }

    Doctor.find({}).remove(function(err) {
        if (err) return console.log(err);
        Doctor.create({
            firstName: 'Doktor',
            lastName: 'Testowy',
            speciality: 'internist',
            color: '#3a87ad'
        }, function(err, doctor) {
            if (err) return console.log(err);
            console.log('finished populating doctors');
            User.create({
                    provider: 'local',
                    name: 'Test Doctor',
                    email: 'doctor@test.com',
                    password: 'doctor',
                    role: 'doctor',
                    active: true,
                    phoneNumber: '444555668',
                    related: [doctor._id]
                }, function(err) {
                    if (err) return console.log(err);
                    console.log('finished populating test doctor');
                }
            );
        });
    });
});

