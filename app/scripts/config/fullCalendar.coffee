'use strict'

months = [ 
	'Styczeń', 'Luty', 'Marzec', 'Kwiecień', 
	'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 
	'Wrzesień', 'Październik', 'Listopad', 'Grudzień' 
]


angular.module('patientNotifierApp').value 'fullCalendarConfig',  
	header:
		right: 'month, agendaWeek, agendaDay, prev, next'
	buttonText:
		month: 'miesiąc'
		agendaWeek: 'tydzień'
		agendaDay: 'dzień'
	timeFormat: 
		agenda: 'H:mm{ - H:mm}'
		'': 'HH:mm'
	dayNames: [ 'Poniedziałek', 'Wtorek', 'Środa', 'Czwartek', 'Piątek', 'Sobota', 'Niedziela' ]
	dayNamesShort: [ 'Pon.', 'Wt.', 'Śr.', 'Czw.', 'Pt.', 'Sob.', 'Niedz.' ]
	monthNames: months
	monthNamesShort: months
	allDaySlot: false
	slotMinutes: 15
	minTime: 0
	maxTime: 24
	axisFormat: 'HH:mm'
	allDayDefault: false
	defaultView: 'agendaWeek'
	unselectAuto: false