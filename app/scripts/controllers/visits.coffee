'use strict'

module = angular.module('patientNotifierApp')

asEvent = (visit) ->
	angular.extend visit, 
		title: "#{visit.patient.lastName} #{visit.patient.firstName}"
		start: new Date(visit.start)
		end: new Date(visit.end)
		color: visit.doctor.color


module.controller 'VisitsCtrl', ($scope, fullCalendarConfig, $modal, Visit) ->
	$scope.visits = []
	$scope.eventsSource = [ $scope.visits ]
	
	$scope.openAddVisitModal = (start, end) ->
		modal = $modal.open
			templateUrl: 'partials/visit'
			controller: 'AddVisitCtrl'
			resolve:
				start: -> start
				end: -> end

		modal.result.then (visit) ->
			$scope.visits.push(asEvent(visit))

		modal.result.finally ->
			$scope.calendar.fullCalendar('unselect')


	isAdmin = $scope.currentUser.role is 'administrator'
	$scope.calendarConfig = _.extend fullCalendarConfig,
		editable: isAdmin
		selectable: isAdmin
		selectHelper: isAdmin
		select: $scope.openAddVisitModal
		viewRender: (view) ->
			visits = Visit.queryFiltered({start: view.visStart, end: view.visEnd})
			visits.$promise.then -> 
				_.each visits, (visit) -> 
					$scope.visits.push(asEvent(visit)) unless _.find($scope.visits, _id: visit._id)?

	
module.controller 'AddVisitCtrl', ($scope, start, end, Visit, Patient, Doctor) ->
	$scope.title = 'Dodaj wizytę'
	$scope.visit = new Visit({start, end})
	$scope.patients = Patient.query()
	$scope.doctors = Doctor.query()

	$scope.submit = (form) ->
		$scope.submitted = true
		return if form.$invalid
		$scope.visit.$save()
			.then -> 
				$scope.$close($scope.visit)
			.catch (err) ->
				if err.data.code is 'overlapping_visit'
					$scope.error = "Lekarz ma już umówioną wizytę w tym terminie."
				else
					$scope.error = "Wystąpił nieznany błąd."