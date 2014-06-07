"use strict"

module = angular.module('patientNotifierApp')


module.service '$confirm', ($modal) ->
	(message, title = 'Potwierdzenie') ->
		modal = $modal.open
			templateUrl: 'partials/confirm'
			controller: 'ConfirmCtrl'
			resolve:
				message: -> message
				title: -> title

		modal.result


module.controller 'ConfirmCtrl', ($scope, message, title) ->
	$scope.message = message
	$scope.title = title