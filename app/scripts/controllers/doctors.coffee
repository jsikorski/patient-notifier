'use strict'


angular.module('patientNotifierApp')
  .controller 'DoctorsCtrl', ($scope, Doctor, $modal) ->
    $scope.doctors = Doctor.query()

    $scope.openAddDoctorModal = ->
      modal = $modal.open
        templateUrl: 'partials/doctor'
        controller: 'AddDoctorCtrl'
        scope: $scope

      modal.result.then (doctor) ->
        $scope.doctors.push(doctor)


angular.module('patientNotifierApp')
  .controller 'DoctorCtrl', ($scope, Doctor, $modal) ->
    $scope.openEditDoctorModal = ->
      modal = $modal.open
        templateUrl: 'partials/doctor'
        controller: 'EditDoctorCtrl'
        scope: $scope
        resolve:
          editedDoctor: ->
            $scope.doctor

      modal.result.then (updatedDoctor) ->
        angular.extend($scope.doctor, updatedDoctor)


angular.module('patientNotifierApp')
  .controller 'AddDoctorCtrl', ($scope, Doctor) ->
    $scope.title = 'Dodaj lekarza'
    $scope.doctor = new Doctor({speciality: 'internist'})

    $scope.submit = (form) ->
      $scope.submitted = true
      return if form.$invalid
      $scope.doctor.$save()
        .then ->
          $scope.$close($scope.doctor)
        .catch (err) ->
          console.log(err)
          $scope.error = "Wystąpił nieznany błąd."



angular.module('patientNotifierApp')
  .controller 'EditDoctorCtrl', ($scope, editedDoctor) ->
    $scope.title = 'Edytuj dane lekarza'
    $scope.doctor = angular.copy(editedDoctor)

    $scope.submit = (form) ->
      $scope.submitted = true
      return if form.$invalid
      $scope.doctor.$update()
        .then ->
          $scope.$close($scope.doctor)
        .catch (err) ->
          console.log(err)
          $scope.error = "Wystąpił nieznany błąd."