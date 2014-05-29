'use strict'


angular.module('patientNotifierApp')
  .filter 'speciality', ->
    (input) ->
      switch input
        when 'internist' then 'internista'
        when 'pediatrician' then 'pediatra'
        else 'inna'