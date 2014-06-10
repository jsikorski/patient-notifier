"use strict"

angular.module('patientNotifierApp')
	.factory 'Patient', ($resource, $filter) ->
		Patient = $resource '/api/patients/:id', 
			{ 
				id: '@_id' 
			},
			{
				update:
					method: 'PATCH'

				search:
					method: 'GET'
					url: '/api/patients/search'
					isArray: true
			}
			
		Patient::getDisplayName = ->
			return '' unless @_id?
			"#{@firstName} #{@lastName}, #{$filter('address')(@address)}"

		return Patient