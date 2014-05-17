"use strict"

angular.module('patientNotifierApp')
	.factory 'Patient', ($resource) ->
		$resource '/api/patients/:id', 
			{ 
				id: '@_id' 
			},
			{
				update:
					method: 'PATCH'
			}