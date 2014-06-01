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
			}

		Patient::getDisplayName = ->
			return '' unless @_id?
			"#{@firstName} #{@lastName}, #{$filter('address')(@address)}"

		return Patient