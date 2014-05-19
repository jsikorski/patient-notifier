'use strict'


angular.module('patientNotifierApp')
.controller 'UsersCtrl', ($scope, User, $modal) ->
  $scope.users = User.query()

  $scope.openAddUserModal = ->
    modal = $modal.open
      templateUrl: 'partials/user'
      controller: 'AddUserCtrl'
      scope: $scope

    modal.result.then (user) ->
      $scope.users.push(user)


angular.module('patientNotifierApp')
.controller 'UserCtrl', ($scope, User, $modal) ->
  $scope.openEditUserModal = ->
    modal = $modal.open
      templateUrl: 'partials/user'
      controller: 'EditUserCtrl'
      scope: $scope
      resolve:
        editedUser: ->
          $scope.user

    modal.result.then (updatedUser) ->
      angular.extend($scope.user, updatedUser)

  $scope.openBlockUserModal = ->
    modal = $modal.open
      templateUrl: 'partials/blockUser'
      controller: 'BlockUserCtrl'
      scope: $scope
      resolve:
        blockedUser: ->
          $scope.user

    modal.result.then (updatedUser) ->
      angular.extend($scope.user, updatedUser)

  $scope.openUnblockUserModal = ->
    modal = $modal.open
      templateUrl: 'partials/blockUser'
      controller: 'UnblockUserCtrl'
      scope: $scope
      resolve:
        blockedUser: ->
          $scope.user

    modal.result.then (updatedUser) ->
      angular.extend($scope.user, updatedUser)

angular.module('patientNotifierApp')
.controller 'AddUserCtrl', ($scope, User) ->
  $scope.title = 'Dodaj użytkownika'
  $scope.user = new User({role: 'user'})

  $scope.submit = (form) ->
    $scope.submitted = true
    return if form.$invalid
    $scope.user.$save()
      .then ->
        $scope.$close($scope.user)
      .then ->
        $scope.$close($scope.user)
      .catch (err) ->
        console.log(err)
        if err.data.code in [ 11000, 11001 ]
          $scope.error = "Użytkownik o podanym adresie e-mail jest już zarejestrowany w systemie."
        else
          $scope.error = "Wystąpił nieznany błąd."

angular.module('patientNotifierApp')
.controller 'EditUserCtrl', ($scope, editedUser) ->
  $scope.title = 'Edytuj dane użytkownika'
  $scope.user = angular.copy(editedUser)

  $scope.submit = (form) ->
    $scope.submitted = true
    return if form.$invalid
    $scope.user.$update()
      .then ->
        $scope.$close($scope.user)
      .catch (err) ->
        console.log(err)
        if err.data.lastErrorObject.code in [ 11000, 11001 ]
          $scope.error = "Użytkownik o podanym adresie e-mail jest już zarejestrowany w systemie."
        else
          $scope.error = "Wystąpił nieznany błąd."


angular.module('patientNotifierApp')
.controller 'BlockUserCtrl', ($scope, blockedUser) ->
  $scope.user = angular.copy(blockedUser)
  $scope.text = "zablokować"
  $scope.title = "Zablokuj użytkownika"

  $scope.submit = ->

    $scope.submitted = true
    $scope.user.active = false
    $scope.user.$update().then ->
      $scope.$close($scope.user)

angular.module('patientNotifierApp')
.controller 'UnblockUserCtrl', ($scope, blockedUser) ->
  $scope.user = angular.copy(blockedUser)
  $scope.text = "odblokować"
  $scope.title = "Odblokuj użytkownika"

  $scope.submit = ->
    $scope.user.active = true
    $scope.submitted = true
    $scope.user.$update().then ->
      $scope.$close($scope.user)