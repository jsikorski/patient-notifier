angular.module('patientNotifierApp')
	.factory 'Visit', ($resource) ->
		Visit = $resource '/api/visits/:id', 
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

		Visit.defaultFields = ['_id', 'title', 'start', 'end', 'color', 'doctor', 'patient']
		return Visit