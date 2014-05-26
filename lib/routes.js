'use strict';

var index = require('./controllers'),
    users = require('./controllers/users'),
    session = require('./controllers/session'),
    patients = require('./controllers/patients'),
    doctors = require('./controllers/doctors');

var middleware = require('./middleware');
var authorize = require('./authorization');

/**
 * Application routes
 */
module.exports = function(app) {
  // Server API Routes
  app.post('/api/users', authorize.asAdministrator(), users.create);
  app.put('/api/users', authorize.asAdministrator(), users.changePassword);
  app.get('/api/users', authorize.asAdministrator(), users.index);
  app.get('/api/users/me', users.me);
  app.get('/api/users/:id', authorize.asAdministrator(), users.show);
  app.patch('/api/users/:id', authorize.asAdministrator(), users.update);

  app.post('/api/session', session.login);
  app.del('/api/session', session.logout);

  app.get('/api/patients', authorize.asAdministrator(), patients.index);
  app.post('/api/patients', authorize.asAdministrator(), patients.create);
  app.patch('/api/patients/:id', authorize.asAdministrator(), patients.update);

  app.get('/api/doctors', authorize.asAdministrator(), doctors.index);
  app.post('/api/doctors', authorize.asAdministrator(), doctors.create);
  app.patch('/api/doctors/:id', authorize.asAdministrator(), doctors.update);

  // All undefined api routes should return a 404
  app.get('/api/*', function(req, res) {
    res.send(404);
  });
  
  // All other routes to use Angular routing in app/scripts/app.js
  app.get('/partials/*', index.partials);
  app.get('/*', middleware.setUserCookie, index.index);
};