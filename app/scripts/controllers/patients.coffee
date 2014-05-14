'use strict'


angular.module('patientNotifierApp')
	.controller 'PatientsCtrl', ($scope, Patient, $modal) ->
		$scope.patients = Patient.query()

		$scope.openAddPatientModal = ->
			modal = $modal.open
				templateUrl: 'partials/addPatient'
				controller: 'AddPatientCtrl'
				scope: $scope
				
			modal.result.then (patient) ->
				$scope.patients.push(patient)


angular.module('patientNotifierApp')
	.controller 'AddPatientCtrl', ($scope, $modalInstance, Patient) ->
		$scope.patient = new Patient()
		
		$scope.submit = (form) ->
			$scope.submitted = true
			return if form.$invalid
			$scope.patient.$save().then -> 
				$scope.$close($scope.patient)