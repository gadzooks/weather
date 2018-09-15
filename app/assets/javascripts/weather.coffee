# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.

$("#weather_index").ready ->
	#alert('on load')

	$('.inlinesparkline').sparkline()

	myvalues = [
		10
		8
		5
		7
		4
		4
		1
	]
	$('.dynamicsparkline').sparkline myvalues

	$('.dynamicbar').sparkline myvalues,
		type: 'bar'
		barColor: 'green'

	$('.inlinebar').sparkline 'html',
		type: 'bar'
		barColor: 'red'

