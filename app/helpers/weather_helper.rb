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

  def add_weekend_class(time, additional_class)
    weekend_class = (time && time.on_weekend?) ? ' weekend ' : ' '
    additional_class + weekend_class
  end

  def icon_class(icon, precipitation)
    precipitation = precipitation.to_f
    mapping = ICON_MAPPING[icon] || 'na'
    additional_class = ''
    if mapping == 'day-cloudy'
      additional_class =
        if precipitation < 0.3
          'day-cloudy-10'
        else
          'day-cloudy-100'
        end
    end

    "wi weather-icon wi-#{mapping} #{mapping} #{additional_class}"
  end

  def precipitation(precipitation)
    precipitation ||= 0
    precipitation *= 100
    precipitation /= 100 if precipitation > 100
    precipitation.round.to_s + '%'
  end

  def sorted_alerts(alerts)
    alerts.sort_by { |a| a.numeric_severity }
  end

  def forecasts_by_region(forecasts)
    # compute locations by region
    locations_by_region = Hash.new{ |h, k| h[k] = []}
    forecasts.keys.each do |loc|
      region = LatitudeLongitudeByRegion.instance.region_for_location loc
      locations_by_region[region] << loc if region
    end

    LatitudeLongitudeByRegion.instance.all_regions.values.each do |region|
      is_new_region = true
      unless locations_by_region[region].empty?
        locations_by_region[region].each do |location|
          yield(is_new_region, region, location, forecasts[location])
          is_new_region = false
        end
      end
    end

  end

end
