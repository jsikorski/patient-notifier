angular.module('patientNotifierApp')
	.factory 'Visit', ($resource) ->
		$resource '/api/visits/:id', 
			{ 
				id: '@_id' 
			},
			{
				queryFiltered:
					url: '/api/visits/filter'
					method: 'POST'
					isArray: true

				update:
					method: 'PATCH'
			}