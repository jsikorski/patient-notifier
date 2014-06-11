'use strict'


angular.module('patientNotifierApp')
  .controller 'FilesCtrl', ($scope, $window) ->
    $scope.downloadFile = (file) ->
      $window.open('/' + file.path, '_blank')