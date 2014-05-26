"use strict"

angular.module('patientNotifierApp')
  .factory 'Doctor', ($resource) ->
    $resource '/api/doctors/:id',
      {
        id: '@_id'
      },
      {
        update:
          method: 'PATCH'
      }