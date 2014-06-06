'use strict'

angular.module('patientNotifierApp')
  .factory 'Mailer', ($resource, $location) ->
    Mailer = $resource '/api/mailer'

    sendActivationMail: (user, callback) ->
      cb = callback or angular.noop
      options = {
        userId: user._id
        subject: 'Account activation'
        text: ($location.absUrl()) + '/' + user._id + '/activate'
      }
      Mailer.save({}, options
      ).$promise