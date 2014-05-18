'use strict'


angular.module('patientNotifierApp')
	.controller 'PatientsCtrl', ($scope, Patient, $modal) ->
		$scope.patients = Patient.query()

		$scope.openAddPatientModal = ->
			modal = $modal.open
				templateUrl: 'partials/patient'
				controller: 'AddPatientCtrl'
				scope: $scope
				
			modal.result.then (patient) ->
				$scope.patients.push(patient)


angular.module('patientNotifierApp')
	.controller 'PatientCtrl', ($scope, Patient, $modal) ->
		$scope.openEditPatientModal = ->
			modal = $modal.open
				templateUrl: 'partials/patient'
				controller: 'EditPatientCtrl'
				scope: $scope
				resolve:
					editedPatient: -> 
						$scope.patient

			modal.result.then (updatedPatient) ->
				angular.extend($scope.patient, updatedPatient)


angular.module('patientNotifierApp')
	.controller 'AddPatientCtrl', ($scope, Patient) ->
		$scope.title = 'Dodaj pacjenta'
		$scope.patient = new Patient()
		
		$scope.submit = (form) ->
			$scope.submitted = true
			return if form.$invalid
			$scope.patient.$save()
				.then -> 
					$scope.$close($scope.patient)
				.catch (err) ->
					if err.data.code in [ 11000, 11001 ]
						$scope.error = "Pacjent o podanym numerze pesel jest już zarejestrowany w systemie."
					else
						$scope.error = "Wystąpił nieznany błąd."


angular.module('patientNotifierApp')
	.controller 'EditPatientCtrl', ($scope, editedPatient) ->
		$scope.title = 'Edytuj dane pacjenta'
		$scope.patient = angular.copy(editedPatient)

		$scope.submit = (form) ->
			$scope.submitted = true
			return if form.$invalid
			$scope.patient.$update()
				.then -> 
					$scope.$close($scope.patient)
				.catch (err) ->
					console.log(err)
					if err.data.lastErrorObject.code in [ 11000, 11001 ]
						$scope.error = "Pacjent o podanym numerze pesel jest już zarejestrowany w systemie."
					else
						$scope.error = "Wystąpił nieznany błąd."