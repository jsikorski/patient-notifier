'use strict'


angular.module('patientNotifierApp')
.controller 'UsersCtrl', ($scope, User, $modal) ->
  $scope.users = User.query()

  $scope.openAddUserModal = ->
    modal = $modal.open
      templateUrl: 'partials/addUser'
      controller: 'AddUserCtrl'
      scope: $scope

    modal.result.then (user) ->
      $scope.users.push(user)


angular.module('patientNotifierApp')
.controller 'AddUserCtrl', ($scope, $modalInstance, User) ->
  $scope.user = new User()

  $scope.submit = (form) ->
    $scope.submitted = true
    return if form.$invalid
    $scope.user.$save().then ->
      $scope.$close($scope.user)