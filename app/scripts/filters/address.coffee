'use strict'


angular.module('patientNotifierApp')
	.filter 'address', ($filter) ->
		(input) ->
			return '' unless input
			"#{$filter('zipCode')(input.zipCode)} #{input.city}, #{input.street}"