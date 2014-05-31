'use strict'

menu = 
  user: [
    { title: 'Wizyty', link: '/' }
    { title: 'Ustawienia', link: '/settings' }
  ]
  administrator: [
    { title: 'Wizyty', link: '/' }
    { title: 'Pacjenci', link: '/patients' }
    { title: 'Lekarze', link: '/doctors' }
    { title: 'Użytkownicy', link: '/users' }
  ]
  doctor: [
      { title: 'Wizyty', link: '/' }
      { title: 'Ustawienia', link: '/settings' }
    ]


angular.module('patientNotifierApp')
  .controller 'NavbarCtrl', ($scope, $location, Auth) ->
    
    $scope.$watch 'currentUser', (user) ->
      $scope.menu = []
      $scope.menu = menu[user.role] if user? 

    $scope.logout = ->
      Auth.logout().then ->
        $location.path "/login"
    
    $scope.isActive = (route) ->
      route is $location.path()