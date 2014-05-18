'use strict'


class ZipCode
	constructor: (@zipCodeString) ->

	isValid: ->
		new RegExp(/^\d{5}$/).test(@getRawFormat())

	getRawFormat: ->
		zipCode = @zipCodeString
		zipCode = zipCode.replace('-', '') if zipCode[2] == '-'
		zipCode


angular.module('patientNotifierApp')
	.directive 'zipCode', ($filter) ->
		restrict: 'A'
		require: 'ngModel'
		link: (scope, element, attrs, ctrl) ->
			ctrl.$parsers.unshift (value) ->
				return '' if _.str.isBlank(value)
				zipCode = new ZipCode(value)
				ctrl.$setValidity('zipCode', zipCode.isValid())
				zipCode.getRawFormat()

			ctrl.$formatters.unshift (value) ->
				$filter('zipCode')(value)