"use strict"

angular.module("patientNotifierApp")
  .factory "User", ($resource) ->
    $resource "/api/users/:id",
      id: "@_id"
    ,
      update:
        method: "PATCH"
        params: {}

      get:
        method: "GET"
        params:
          id: "me"
