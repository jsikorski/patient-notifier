'use strict'

angular.module('patientNotifierApp')
  .factory 'Activation', ($resource) ->
    $resource '/api/users/:id/activate',
      id: '@id',
        update:
          method: 'PATCH'

        get:
          method: 'GET'