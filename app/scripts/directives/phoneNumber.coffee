'use strict'


class PhoneNumber
  constructor: (@phoneNumberString) ->

  isValid: ->
    @_hasCorrectFormat()

  _hasCorrectFormat: ->
    new RegExp(/^\d{9}$/).test(@phoneNumberString)


angular.module('patientNotifierApp')
  .directive 'phoneNumber', ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attrs, ctrl) ->
      ctrl.$parsers.unshift (value) ->
        ctrl.$setValidity('phoneNumber', new PhoneNumber(value).isValid())
        value