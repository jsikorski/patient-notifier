'use strict'

angular.module('patientNotifierApp')
	.controller 'PatientsCtrl', ($scope, Patient) ->
		$scope.patients = Patient.query()