'use strict'


class Pesel
	constructor: (@peselString) ->

	isValid: ->
		@_hasCorrectFormat() and @_hasValidChecksum()

	_hasCorrectFormat: ->
		new RegExp(/^\d{11}$/).test(@peselString)

	_hasValidChecksum: ->
		digits = []
		digits.push(Number.parseInt(digit)) for digit in @peselString
		return (digits[0] + 3 * digits[1] + 7 * digits[2] + 
			9 * digits[3] + digits[4] + 3 * digits[5] + 
			7 * digits[6] + 9 * digits[7] + digits[8] + 
			3 * digits[9] + digits[10]) % 10 == 0


angular.module('patientNotifierApp')
	.directive 'pesel', ->
		restrict: 'A'
		require: 'ngModel'
		link: (scope, element, attrs, ctrl) ->
			ctrl.$parsers.unshift (value) ->
				ctrl.$setValidity('pesel', new Pesel(value).isValid())
				value