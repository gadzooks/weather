module WeatherHelper
  ICON_MAPPING = {
    'clear-day' => 'day-sunny',
    'clear-night' => 'night-clear',
    'rain' => 'rain',
    'snow' => 'snow',
    'sleet' => 'sleet',
    'wind' => 'strong-wind',
    'fog' => 'fog',
    'cloudy' => 'cloudy',
    'partly-cloudy-day' => 'day-cloudy',
    'partly-cloudy-night' => 'night-partly-cloudy',
    'hail' => 'hail',
    'thunderstorm' => 'thunderstorm',
    'tornado' => 'tornado',
  }

  def icon_class(icon, precipitation)
    precipitation = precipitation.to_f
    mapping = ICON_MAPPING[icon] || 'na'
    addional_class = ''
    if mapping == 'day-cloudy'
      addional_class =
        if precipitation < 0.3
          'day-cloudy-10'
        else
          'day-cloudy-100'
        end
    end

    "wi weather-icon wi-#{mapping} #{mapping} #{addional_class}"
  end

  def precipitation(precipitation)
    precipitation ||= 0
    (precipitation * 100).round.to_s + '%'
  end
end
