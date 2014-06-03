'use strict'


angular.module('patientNotifierApp')
  .controller 'RelatedCtrl', ($scope, Related, User, $modal, $location) ->
    userId = "#{$location.path()}".split('/')[2]
    $scope.related = Related.get({id: userId})
    $scope.user = User.get({id: userId})

    $scope.openAddRelatedPatientModal = ->
      modal = $modal.open
        templateUrl: 'partials/addRelated'
        controller: 'AddRelatedPatientCtrl'
        scope: $scope
        resolve:
          editedUser: ->
            $scope.user

      modal.result.then (updatedUser) ->
        angular.extend($scope.user, updatedUser)

    $scope.openAddRelatedDoctorModal = ->
      modal = $modal.open
        templateUrl: 'partials/addRelated'
        controller: 'AddRelatedDoctorCtrl'
        scope: $scope
        resolve:
          editedUser: ->
            $scope.user

      modal.result.then (updatedUser) ->
        angular.extend($scope.user, updatedUser)

    $scope.toDictionary = (keys, value) ->
      dictionary = {}
      for key in keys
        dictionary[key._id] = { related: key, checked: value}
      return dictionary



angular.module('patientNotifierApp')
  .controller 'RelatedPatientCtrl', ($scope, User, Related, Patient, $modal) ->

    $scope.openRemoveRelatedPatientModal = ->
      modal = $modal.open
        templateUrl: 'partials/removeRelated'
        controller: 'RemoveRelatedPatientCtrl'
        scope: $scope
        resolve:
          editedUser: -> $scope.user
          removedPatient: -> $scope.patient

      modal.result.then (updatedUser) ->
        angular.extend($scope.user, updatedUser)

    $scope.submit = ->
      $scope.submitted = true
      $scope.user.$update().then ->
        $scope.$close($scope.user)



angular.module('patientNotifierApp')
  .controller 'RelatedDoctorCtrl', ($scope, User, Related, Doctor, $modal) ->

    $scope.openRemoveRelatedDoctorModal = ->
      modal = $modal.open
        templateUrl: 'partials/removeRelated'
        controller: 'RemoveRelatedDoctorCtrl'
        scope: $scope
        resolve:
          editedUser: -> $scope.user
          removedDoctor: -> $scope.doctor

      modal.result.then (updatedUser) ->
        angular.extend($scope.user, updatedUser)


angular.module('patientNotifierApp')
  .controller 'AddRelatedDoctorCtrl', ($scope, editedUser, Doctor) ->
    $scope.user = angular.copy(editedUser)
    $scope.$watchCollection 'doctors', (doctors) ->
      filteredDoctors = doctors.filter (doctor) -> doctor._id not in $scope.user.related
      $scope.selectedDoctors = $scope.toDictionary(filteredDoctors, false)
    $scope.doctors = Doctor.query()
    $scope.title = 'Wybierz lekarza'

    $scope.submit = ->
      $scope.submitted = true

      $scope.user.related = []
      $scope.related.doctors = []
      for own key, value of $scope.selectedDoctors
        console.log key
        if value.checked && $scope.user.related.length == 0
          $scope.user.related.push(key)
          $scope.related.doctors.push(value.related)
      console.log $scope.user.related
      $scope.user.$update()
        .then ->
          $scope.$close($scope.user)


angular.module('patientNotifierApp')
  .controller 'AddRelatedPatientCtrl', ($scope, editedUser, Patient) ->
    $scope.user = angular.copy(editedUser)
    $scope.$watchCollection 'patients', (patients) ->
      filteredPatients = patients.filter (patient) -> patient._id not in $scope.user.related
      $scope.selectedPatients = $scope.toDictionary(filteredPatients, false)
    $scope.patients = Patient.query()
    $scope.title = "Wybierz pacjentów"


    $scope.submit = ->
      $scope.submitted = true
      for own key, value of $scope.selectedPatients
        if value.checked && key not in $scope.user.related
          $scope.user.related.push(key)
          $scope.related.patients.push(value.related)
      console.log $scope.user.related
      $scope.user.$update()
        .then ->
          $scope.$close($scope.user)


angular.module('patientNotifierApp')
  .controller 'RemoveRelatedDoctorCtrl', ($scope, editedUser, removedDoctor) ->
    $scope.user = angular.copy(editedUser)
    $scope.removedDoctor = removedDoctor

    $scope.submit = ->
      $scope.submitted = true
      $scope.user.related = []
      $scope.related.doctors = []
      $scope.user.$update()
        .then ->
          $scope.$close($scope.user)


angular.module('patientNotifierApp')
  .controller 'RemoveRelatedPatientCtrl', ($scope, editedUser, removedPatient) ->
    $scope.user = angular.copy(editedUser)
    $scope.removedPatient = removedPatient

    $scope.submit = ->
      $scope.submitted = true
      $scope.user.related = $scope.user.related.filter (patient) -> patient isnt removedPatient._id
      $scope.related.patients = $scope.related.patients.filter (patient) -> patient._id isnt removedPatient._id
      $scope.user.$update()
        .then ->
          $scope.$close($scope.user)
