angular.module('patientNotifierApp').factory 'VisitEventsCollection', (Visit) ->
	
	class VisitEventsCollection
		constructor: (@models) ->
			@models ?= []

		add: (visit) =>
			@models.push(@asEvent(visit))

		update: (updatedVisit) =>
			visit = _.find(@models, _id: updatedVisit._id)
			angular.extend(visit, @asEvent(updatedVisit))

		remove: (visit) =>
			@models.splice(@models.indexOf(visit), 1)

		query: (start, end) =>
			visits = Visit.queryFiltered({start, end})
			visits.$promise.then => 
				_.each visits, (visit) => 
					@models.push(@asEvent(visit)) unless _.find(@models, _id: visit._id)?

		asEvent: (visit) ->
			angular.extend visit, 
				title: "#{visit.patient.lastName} #{visit.patient.firstName}"
				start: new Date(visit.start)
				end: new Date(visit.end)
				color: visit.doctor.color



	return VisitEventsCollection