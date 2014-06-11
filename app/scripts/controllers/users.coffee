'use strict'


angular.module('patientNotifierApp')
	.controller 'UsersCtrl', ($scope, User, $modal) ->
		$scope.users = User.query()
		$scope.roles = ['user', 'administrator', 'doctor']

		$scope.openAddUserModal = ->
			modal = $modal.open
				templateUrl: 'partials/user'
				controller: 'AddUserCtrl'
				scope: $scope

			modal.result.then (user) ->
				$scope.users.push(user)


angular.module('patientNotifierApp')
	.controller 'UserCtrl', ($scope, User, $modal, $location, $upload, $notify) ->
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

		$scope.openRelated = ->
			$location.path ('/users/' + $scope.user._id + '/related')

		$scope.onFileSelect = ($files) ->
			$upload.upload(
				url: '/api/users/' + $scope.user._id + '/attachments'
				file: $files[0]
				).success(-> $notify.success('Dodawanie pliku zakończone pomyślnie'))


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
				.catch (err) ->
					if err.data.code in [ 11000, 11001 ]
						$scope.error = "Użytkownik o podanym adresie e-mail lub numerze telefonu jest już zarejestrowany w systemie."
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
			$scope.user.$update()
				.then ->
					$scope.$close($scope.user)


angular.module('patientNotifierApp')
	.controller 'UnblockUserCtrl', ($scope, blockedUser) ->
		$scope.user = angular.copy(blockedUser)
		$scope.text = "odblokować"
		$scope.title = "Odblokuj użytkownika"

		$scope.submit = ->
			$scope.user.active = true
			$scope.submitted = true
			$scope.user.$update()
				.then ->
					$scope.$close($scope.user)


angular.module('patientNotifierApp')
	.controller 'ActivateUserCtrl', ($scope, Activation, $location, $http, $notify) ->
		$scope.userId = "#{$location.path()}".split('/')[2]
		$scope.password = null
		$scope.repeatPassword = null

		$scope.activate = (form) ->
			$scope.submitted = true
			if form.$valid && $scope.password == $scope.repeatPassword
				$http(
					method: 'PATCH'
					url: "/api/users/#{$scope.userId}/activate",
					data: { password: $scope.password})
				.success(() -> $location.path '/login')
				.error(-> $notify.error('Wystąpił nieznany błąd.'))


