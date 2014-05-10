'use strict'

angular.module('patientNotifierApp')
  .factory 'Session', ($resource) ->
    $resource '/api/session/'
