"use strict"

patientNotifier = angular.module('patientNotifierApp')


patientNotifier.service '$confirm', ($modal) ->
	(message, title = 'Potwierdzenie') ->
		modal = $modal.open
			templateUrl: 'partials/confirm'
			controller: 'ConfirmCtrl'
			resolve:
				message: -> message
				title: -> title

		modal.result


patientNotifier.controller 'ConfirmCtrl', ($scope, message, title) ->
	$scope.message = message
	$scope.title = title