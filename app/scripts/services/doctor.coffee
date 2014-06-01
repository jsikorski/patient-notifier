"use strict"

angular.module('patientNotifierApp')
	.factory 'Doctor', ($resource, $filter) ->
		Doctor = $resource '/api/doctors/:id',
			{
				id: '@_id'
			},
			{
				update:
					method: 'PATCH'
			}

		Doctor::getDisplayName = ->
			return '' unless @_id?
			"#{@lastName} #{@firstName}, #{$filter('speciality')(@speciality)}"

		return Doctor