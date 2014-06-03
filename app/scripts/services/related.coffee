"use strict"

angular.module("patientNotifierApp")
.factory "Related", ($resource) ->
  $resource "/api/users/:id/related",
    id: "@_id"
  ,
    update:
      method: "PATCH"
      params: {}

    get:
      method: "GET"
      params: {}