"use strict"

$.growl.default_options.position.align = 'center'


class Notify
	success: (message) ->
		$.growl({ message, type: 'success' })

	error: (message) ->
		$.growl({ message, type: 'danger' })

angular.module('patientNotifierApp').service '$notify', ->
	new Notify()