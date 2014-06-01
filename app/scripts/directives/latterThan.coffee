'use strict'


angular.module('patientNotifierApp')
	.directive 'latterThan', ($filter) ->
		restrict: 'A'
		require: 'ngModel'
		link: (scope, element, attrs, ctrl) ->
			validate = (value) ->
				minDate = new Date(attrs.latterThan.replace(/"/g, '')).getTime()
				currentDate = new Date(value).getTime()

				if currentDate <= minDate
					ctrl.$setValidity('latterThan', false)
				else
					ctrl.$setValidity('latterThan', true)

				return value

			ctrl.$parsers.push(validate)
			ctrl.$formatters.push(validate)
			attrs.$observe('latterThan', -> validate(ctrl.$viewValue))