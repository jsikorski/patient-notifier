'use strict'


angular.module('patientNotifierApp').directive 'appendHtml', ($compile) ->
	priority: 0
	restrict: 'E'
	scope:
		selector: '@selector'
		method: '@method'

	link: (scope, element) ->
		_.defer ->
			result = $compile(element.html())(scope.$parent)
			$(scope.selector)[scope.method](result)