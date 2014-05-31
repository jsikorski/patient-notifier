'use strict'

angular.module('patientNotifierApp')
	.controller 'VisitsCtrl', ($scope, fullCalendarConfig) ->
		isAdmin = $scope.currentUser.role is 'administrator'

		$scope.calendarConfig = _.extend fullCalendarConfig,
			editable: isAdmin
			selectable: isAdmin
			selectHelper: isAdmin
			select: (start, end) ->
				alert("#{start} - #{end}")
				$scope.calendar.fullCalendar('unselect')

		$scope.eventsSource = [ { events: [] } ]