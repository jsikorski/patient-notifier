'use strict'

module = angular.module('patientNotifierApp')

asEvent = (visit) ->
	angular.extend visit, 
		title: "#{visit.patient.lastName} #{visit.patient.firstName}"
		start: new Date(visit.start)
		end: new Date(visit.end)
		color: visit.doctor.color

errorHandler = ($scope) ->
	(err) ->
		if err.data.code is 'overlapping_visit'
			$scope.error = 'Lekarz ma już umówioną wizytę w tym terminie.'
		else
			$scope.error = 'Wystąpił nieznany błąd.'


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

	$scope.openEditVisitModal = (visit) ->
		modal = $modal.open
			templateUrl: 'partials/visit'
			controller: 'EditVisitCtrl'
			resolve:
				editedVisit: -> visit

		update = (updatedVisit) ->
			visit = _.find($scope.visits, _id: updatedVisit._id)
			angular.extend(visit, asEvent(updatedVisit))

		revertFunc = arguments[3] if _.isFunction(arguments[3])
		revertFunc = arguments[4] if _.isFunction(arguments[4])
		revert = ->	revertFunc() if revertFunc?

		modal.result.then(update, revert)
		modal.result.finally(->	$scope.calendar.fullCalendar('unselect'))


	isAdmin = $scope.currentUser.role is 'administrator'
	$scope.eventSignature = (event) -> event.color
	$scope.calendarConfig = _.extend fullCalendarConfig,
		editable: isAdmin
		selectable: isAdmin
		selectHelper: isAdmin
		select: $scope.openAddVisitModal
		eventClick: $scope.openEditVisitModal
		eventDrop: $scope.openEditVisitModal
		eventResize: $scope.openEditVisitModal
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
			.then(-> $scope.$close($scope.visit))
			.catch(errorHandler($scope))


module.controller 'EditVisitCtrl', ($scope, editedVisit, Visit, Patient, Doctor) ->
	$scope.title = 'Edytuj wizytę'
	$scope.visit = new Visit(_.pick(editedVisit, Visit.defaultFields))
	$scope.visit.patient = $scope.visit.patient._id
	$scope.visit.doctor = $scope.visit.doctor._id
	$scope.patients = Patient.query()
	$scope.doctors = Doctor.query()

	$scope.submit = (form) ->
		$scope.submitted = true
		return if form.$invalid
		$scope.visit.$update()
			.then($scope.$close)
			.catch(errorHandler($scope))