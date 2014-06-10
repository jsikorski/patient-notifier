'use strict';

var index = require('./controllers'),
    users = require('./controllers/users'),
    session = require('./controllers/session'),
    patients = require('./controllers/patients'),
    doctors = require('./controllers/doctors'),
    visits = require('./controllers/visits'),
    mailer = require('./controllers/mailer'),
    synchronization = require('./synchronization/synchronization');

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
  app.get('/api/users/:id/activate', users.show);
  app.patch('/api/users/:id/activate', users.activate);
  app.get('/api/users/:id', authorize.asAdministrator(), users.get);
  app.patch('/api/users/:id', authorize.asAdministrator(), users.update);
  app.get('/api/users/:id/related', authorize.asAdministrator(), users.showRelated);
  app.patch('/api/users/:id/related', authorize.asAdministrator(), users.update);
  app.patch('/api/users/:id/notificationChannels', users.updateNotificationChannels);
  app.get('/api/users/:id/synchronize', synchronization.synchronize);
  app.get('/api/users/synchronizeCallback', synchronization.synchronizeCallback);

  app.post('/api/session', session.login);
  app.del('/api/session', session.logout);

  app.get('/api/patients', authorize.asAdministrator(), patients.index);
  app.post('/api/patients', authorize.asAdministrator(), patients.create);
  app.patch('/api/patients/:id', authorize.asAdministrator(), patients.update);

  app.get('/api/doctors', authorize.asAdministrator(), doctors.index);
  app.post('/api/doctors', authorize.asAdministrator(), doctors.create);
  app.patch('/api/doctors/:id', authorize.asAdministrator(), doctors.update);

  app.post('/api/visits/filter', visits.index);
  app.post('/api/visits', authorize.asAdministrator(), visits.create);
  app.patch('/api/visits/:id', authorize.asAdministrator(), visits.update);
  app.delete('/api/visits/:id', authorize.asAdministrator(), visits.delete);

  app.post('/api/mailer', mailer.send);

  // All undefined api routes should return a 404
  app.get('/api/*', function(req, res) {
    res.send(404);
  });
  
  // All other routes to use Angular routing in app/scripts/app.js
  app.get('/partials/*', index.partials);
  app.get('/*', middleware.setUserCookie, index.index);
};