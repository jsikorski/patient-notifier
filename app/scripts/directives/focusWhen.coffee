'use strict'


angular.module('patientNotifierApp')
  .directive 'focusWhen', ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      scope.$watch attrs.focusWhen, (value) ->
        _.delay(-> element[0].focus()) if value