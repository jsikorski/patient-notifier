'use strict'


angular.module('patientNotifierApp')
.controller 'RelatedCtrl', ($scope, Related, $modal, $location) ->
  $scope.related = Related.get({id: "#{$location.path()}".split('/')[2]})

  $scope.submit = ->
    $scope.submitted = true
    $scope.related.user.$update().then ->
      $scope.$close($scope.related.user)

    $scope.openAddRelatedDoctorModal = ->
      modal = $modal.open
        templateUrl: 'partials/addRelated'
        controller: 'AddRelatedDoctorCtrl'
        scope: $scope
        resolve:
          editedUser: ->
            $scope.related.user

      modal.result.then (updatedUser) ->
        angular.extend($scope.user, updatedUser)

    $scope.openAddRelatedPatientModal = ->
      modal = $modal.open
        templateUrl: 'partials/addRelated'
        controller: 'AddRelatedPatientCtrl'
        scope: $scope
        resolve:
          editedUser: ->
            $scope.related.user

      modal.result.then (updatedUser) ->
        angular.extend($scope.user, updatedUser)


angular.module('patientNotifierApp')
  .controller 'RelatedPatientCtrl', ($scope, User, Related, Patient, $modal) ->

    $scope.openRemoveRelatedPatientModal = ->
      modal = $modal.open
        templateUrl: 'partials/removeRelated'
        controller: 'RemoveRelatedPatientCtrl'
        scope: $scope
        resolve:
          editedUser: ->
            $scope.related.user
          removedPatient: ->
            $scope.patient

      modal.result.then (updatedUser) ->
        angular.extend($scope.related.user, updatedUser)


angular.module('patientNotifierApp')
  .controller 'RelatedDoctorCtrl', ($scope, User, Related, Doctor, $modal) ->

    $scope.openRemoveRelatedDoctorModal = ->
      modal = $modal.open
        templateUrl: 'partials/removeRelated'
        controller: 'RemoveRelatedDoctorCtrl'
        scope: $scope
        resolve:
          editedUser: ->
            $scope.related.user
          removedDoctor: ->
            $scope.doctor

      modal.result.then (updatedUser) ->
        angular.extend($scope.user, updatedUser)


angular.module('patientNotifierApp')
  .controller 'AddRelatedDoctorCtrl', ($scope, editedUser, Doctor) ->
    $scope.user = angular.copy(editedUser)
    $scope.doctors = Doctor.query()

    $scope.submit = ->
      $scope.submitted = true
      $scope.user.$update()
        .then ->
          $scope.$close($scope.user)


angular.module('patientNotifierApp')
  .controller 'AddRelatedPatientCtrl', ($scope, editedUser, Patient) ->
    $scope.user = angular.copy(editedUser)
    $scope.patients = Patient.query()

    $scope.submit = ->
      $scope.submitted = true
      $scope.user.$update()
        .then ->
          $scope.$close($scope.user)


angular.module('patientNotifierApp')
.controller 'RemoveRelatedDoctorCtrl', ($scope, editedUser, removedDoctor) ->
  $scope.user = angular.copy(editedUser)
  $scope.removedDoctor = removedDoctor
  console.log $scope.removedDoctor
  console.log $scope.user

  $scope.submit = ->
    $scope.submitted = true
    $scope.user.related = []
    console.log $scope.user
    $scope.user.$update()
      .then ->
        $scope.$close($scope.user)


angular.module('patientNotifierApp')
.controller 'RemoveRelatedPatientCtrl', ($scope, editedUser, removedPatient) ->
  $scope.user = angular.copy(editedUser)
  $scope.removedPatient = removedPatient

  $scope.submit = ->
    $scope.submitted = true
    $scope.user.related = $scope.user.related.filter (patient) -> patient isnt removedPatient
    $scope.user.$update()
      .then ->
        $scope.$close($scope.user)
