'use strict'

patientNotifier = angular.module('patientNotifierApp')

cancelVisitMessage = 'Czy na pewno chcesz odwołać tę wizytę?'

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


patientNotifier.controller 'VisitsCtrl', ($scope, fullCalendarConfig, $modal, $confirm, $notify, VisitEventsCollection) ->
	events = new VisitEventsCollection()
	$scope.eventsSource = [ events.models ]


	$scope.openAddVisitModal = (start, end) ->
		modal = $modal.open
			templateUrl: 'partials/visit'
			controller: 'AddVisitCtrl'
			resolve:
				start: -> start
				end: -> end

		modal.result
			.then(events.add)
			.finally ->
				$scope.calendar.fullCalendar('unselect')


	$scope.openEditVisitModal = (visit) ->
		return unless $scope.currentUser.role is 'administrator'

		modal = $modal.open
			templateUrl: 'partials/visit'
			controller: 'EditVisitCtrl'
			resolve:
				editedVisit: -> visit

		revertFunc = arguments[3] if _.isFunction(arguments[3])
		revertFunc = arguments[4] if _.isFunction(arguments[4])
		revert = ->	revertFunc() if revertFunc?
		revertOrCancel = (reason) ->
			return revert() unless reason is 'cancel-visit'
			
			deleteVisit = ->
				visit.$delete()
					.then(-> events.remove(visit))
					.catch (err) -> 
						return events.remove(visit) if err.status is 404
						$notify.error("Wystąpił nieznany błąd.")
						revert()

			$confirm(cancelVisitMessage).then(deleteVisit, revert)

		modal.result.then(events.update, revertOrCancel)
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
		viewRender: (view) -> events.query(view.visStart, view.visEnd)

	
patientNotifier.controller 'AddVisitCtrl', ($scope, start, end, Visit, Patient, Doctor) ->
	$scope.title = 'Dodaj wizytę'
	$scope.visit = new Visit({start, end})
	$scope.patients = Patient.query()
	$scope.doctors = Doctor.query()
	$scope.mode = 'add'

	$scope.submit = (form) ->
		$scope.submitted = true
		return if form.$invalid
		$scope.visit.$save()
			.then(-> $scope.$close($scope.visit))
			.catch(errorHandler($scope))


patientNotifier.controller 'EditVisitCtrl', ($scope, editedVisit, Visit, Patient, Doctor) ->
	$scope.title = 'Edytuj wizytę'
	$scope.visit = new Visit(_.pick(editedVisit, Visit.defaultFields))
	$scope.visit.patient = $scope.visit.patient._id
	$scope.visit.doctor = $scope.visit.doctor._id
	$scope.patients = Patient.query()
	$scope.doctors = Doctor.query()
	$scope.mode = 'edit'

	$scope.submit = (form) ->
		$scope.submitted = true
		return if form.$invalid
		$scope.visit.$update()
			.then($scope.$close)
			.catch(errorHandler($scope))