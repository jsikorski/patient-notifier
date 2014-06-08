'use strict'

angular.module('patientNotifierApp')
  .factory 'Activation', ($resource) ->
    $resource '/api/users/:id/activate',
      id: '@id',
        save:
          method: 'POST'

        get:
          method: 'GET'