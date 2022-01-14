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
    'partly-cloudy-day' => 'cloudy',
    'partly-cloudy-night' => 'night-partly-cloudy',
    'hail' => 'hail',
    'thunderstorm' => 'thunderstorm',
    'tornado' => 'tornado',
  }

  def found_api_errors?(make_actual_call, f_summary)
    return make_actual_call && f_summary != nil && !f_summary.errors.blank?
  end

  def shorten_me(str)
    truncate(str, length: 10, separator: ' ', omission: '')
  end

  def hh_mm_in_pdt(time)
    if time.respond_to? :in_time_zone
      time.in_time_zone("Pacific Time (US & Canada)").strftime('%l:%M %P')
    else
      time
    end
  end

  def add_weekend_class(time, additional_class, show_alert_class = false)
    if show_alert_class
      additional_class + ' alert-cell-triangle '
    end

    weekend_class = (time && time.on_weekend?) ? ' weekend ' : ' '
    additional_class + weekend_class
  end

  def icon_class(icon, precipitation, cloud_cover, max_temp)
    mapping = ICON_MAPPING[icon] || 'na'
    additional_class = ''
    if mapping == 'cloudy'
      unless precipitation.blank?
        precipitation = precipitation.to_f
        additional_class =
          if precipitation < 30
            'sunshine-10'
          elsif precipitation < 60
            'sunshine-50'
          else
            'sunshine-100'
          end
      end
      cloud_cover = cloud_cover.to_f
      # OVERRIDE sunshine color to greyish if cloud cover is high
      additional_class = 'sunshine-50' if cloud_cover > 60

      # show a bit of sun peeking out if there is less than 50% cloud cover
      mapping = 'day-cloudy' if cloud_cover <= 50
    elsif mapping == 'day-sunny' && max_temp >= 80
      mapping = 'hot'
    end

    if max_temp >= 90
      additional_class += ' high-temp-wi-hotter'
    elsif max_temp >= 80
      additional_class += ' high-temp-wi-hot'
    end


    "wi weather-icon wi-#{mapping} #{mapping} #{additional_class}"
  end


  def moon_phase_icon_class(moon_phase)
    moon_phase = moon_phase.to_f
    title, mapping = case moon_phase
              when 0, 1
                ['New Moon : ' + moon_phase.to_s, 'new']
              when 0.25
                ['First Quarter Moon : ' + moon_phase.to_s, 'first-quarter']
              when 0.5
                ['Full Moon : ' + moon_phase.to_s, 'full']
              when 0.75
                ['Last Quarter Moon : ' + moon_phase.to_s, 'last-quarter']
              else
                []
              end
    unless mapping
      title, mapping =
        if(moon_phase > 0.75)
          ['Waning Crescen Moon : ' + moon_phase.to_s, 'waning-crescent-' + moon_phase_numeric(moon_phase)]
        elsif(moon_phase > 0.5)
          ['Waning Gibbous Moon : ' + moon_phase.to_s, 'waning-gibbous-' + moon_phase_numeric(moon_phase)]
        elsif(moon_phase > 0.25)
          ['Waxing Gibbous Moon : ' + moon_phase.to_s, 'waxing-gibbous-' + moon_phase_numeric(moon_phase)]
        elsif(moon_phase > 0)
          ['Waxing Crescent Moon : ' + moon_phase.to_s, 'waxing-crescent-' + moon_phase_numeric(moon_phase)]
        end
    end
    [title, "wi weather-icon wi-moon-#{mapping}"]
  end

  # convert range of values between 0.1 to 0.24 to 1 to 6
  def moon_phase_numeric(moon_phase)
    moon_phase %= 0.25 # get the quadrant value
    moon_phase *= 100  # convert fraction to number
    # 28 total values - 4 values for full moon, new moon and 2 quarter moons
    # these remaining 24 values are to be divided into 6 regions so each region
    # will have rage of 4
    moon_phase /= 4.0
    # fix issue of rounding
    moon_phase = 1 if moon_phase.round.zero?

    return moon_phase.round.to_s
  end


  def precipitation(precipitation)
    precipitation ||= 0
    precipitation *= 100
    precipitation /= 100 if precipitation > 100
    precipitation.round.to_s + '%'
  end

  def precipitationAmount(p)
    if p
      if p == 0 || p.round(1) == 0
        return '-'
      end

      return p.round(1).to_s + '"'
    else
      return '-'
    end
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
