'use strict'

angular.module('patientNotifierApp')
	.controller 'SettingsCtrl', ($scope, User, Auth, $http, $notify) ->
		$scope.errors = {}

		$scope.changePassword = (form) ->
			$scope.submitted = true
			
			if form.$valid
				Auth.changePassword($scope.user.oldPassword, $scope.user.newPassword)
				.then ->
					$scope.message = 'Password successfully changed.'
				.catch ->
					form.password.$setValidity 'mongoose', false
					$scope.errors.other = 'Incorrect password'

		$scope.$watch 'currentUser.notificationChannels', ((oldValue, newValue) ->
			return if oldValue is newValue

			$http(
				method: 'PATCH'
				url: "/api/users/#{$scope.currentUser._id}/notificationChannels",
				data: { notificationChannels: $scope.currentUser.notificationChannels })
					.success((channels) -> $scope.currentUser.notificationChannels = channels)
					.error(-> $notify.error('Wystąpił nieznany błąd. Prosimy odświeżyć stronę.'))
			), true


		$scope.synchWithGoogle = ->
			$http(
				method: 'GET'
				url: "/api/users/#{$scope.currentUser._id}/synchronize",
				data: { })
					.success(() -> )
					.error(-> $notify.error('Wystąpił nieznany błąd. Prosimy odświeżyć stronę.'))