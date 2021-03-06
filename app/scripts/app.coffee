'use strict'

angular.module('patientNotifierApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ui.bootstrap',
  'ui.calendar',
  'ui.bootstrap.datetimepicker',
  'angularFileUpload'
])
  .config ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'partials/visits'
        controller: 'VisitsCtrl'
      .when '/patients',
        templateUrl: 'partials/patients'
        controller: 'PatientsCtrl'
      .when '/doctors',
        templateUrl: 'partials/doctors'
        controller: 'DoctorsCtrl'
      .when '/users',
          templateUrl: 'partials/users'
          controller: 'UsersCtrl'
      .when '/users/:id/related',
          templateUrl: 'partials/related'
          controller: 'RelatedCtrl'
      .when '/users/:id/activate',
          templateUrl: 'partials/setPassword'
          controller: 'ActivateUserCtrl'
      .when '/login',
        templateUrl: 'partials/login'
        controller: 'LoginCtrl'
      .when '/signup', 
        templateUrl: 'partials/signup'
        controller: 'SignupCtrl'
      .when '/settings',
        templateUrl: 'partials/settings'
        controller: 'SettingsCtrl'
      .when '/files',
        templateUrl: 'partials/files'
        controller: 'FilesCtrl'
      .otherwise
        redirectTo: '/'

    $locationProvider.html5Mode true
  
    # Intercept 401s and redirect you to login
    $httpProvider.interceptors.push ['$q', '$location', ($q, $location) ->
      responseError: (response) ->
        if response.status is 401
          $location.path '/login'
          $q.reject response
        else
          $q.reject response
    ]
  .run ($rootScope, $location, Auth) ->
    
    # Redirect to login if route requires auth and you're not logged in
    $rootScope.$on '$routeChangeStart', (event, next) ->
      if not /\/users\/[a-z0-9]+\/activate/.test($location.path())
        $location.path '/login'  if not Auth.isLoggedIn()