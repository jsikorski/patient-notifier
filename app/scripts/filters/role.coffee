'use strict'


angular.module('patientNotifierApp')
  .filter 'role', ->
    (input) ->
      switch input
        when 'administrator' then 'administrator'
        when 'doctor' then 'lekarz'
        else 'użytkownik'