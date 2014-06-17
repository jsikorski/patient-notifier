'use strict'

describe 'Controller: PatientsCtrl', ->
	beforeEach module 'patientNotifierApp'

	PatientsCtrl = {}
	scope = {}
	$httpBackend = {}

	beforeEach inject (_$httpBackend_, $controller, $rootScope) ->
		$httpBackend = _$httpBackend_
		$httpBackend.expectGET('/api/patients').respond [
			{ _id: '1' }, 
			{ _id: '2' }, 
			{ _id: '3' }
		]
		scope = $rootScope.$new()
		PatientsCtrl = $controller 'PatientsCtrl', { $scope: scope }

	it 'should attach a list of patients to the scope', ->
		expect(scope.patients.length).toBe 0
		$httpBackend.flush()
		expect(scope.patients.length).toBe 3