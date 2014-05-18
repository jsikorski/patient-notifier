'use strict'


angular.module('patientNotifierApp')
	.filter 'zipCode', ->
		(input) ->
			return '' if _.str.isBlank(input) or input.length < 5
			input.substr(0, 2) + '-' + input.substr(2)