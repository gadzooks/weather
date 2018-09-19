# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.

$("#weather_index").ready ->
	#alert('on load')

	$('.inlinesparkline').sparkline 'html',
    width: '50px'
    enableTagOptions: 'true'
    tooltipFormat: '{{value:levels}} - {{value}}'
    tooltipValueLookups:
      levels: $.range_map
        ':20': 'Low'
        '30:60': 'Medium'
        '70:': 'High'

	$('.inlinesparkline00').bind 'sparklineClick', (ev) ->
		sparkline = ev.sparklines[0]
		region = sparkline.getCurrentRegionFields()
		alert 'Clicked on x=' + region.x + ' y=' + region.y


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

