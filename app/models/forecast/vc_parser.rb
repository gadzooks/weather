module Forecast
class VcParser
  DAILY_FORECAST = 'days'
  ALERTS = 'alerts'

  def self.parse(json_response, errors)
    json_response ||= {}

    all_alerts, forecast_by_location, max_daily_data_points = parse_weather_responses(json_response)

    Forecast::Summary.new(forecast_by_location, max_daily_data_points, all_alerts, errors)
  end

  #######
  private
  #######

  def self.parse_weather_responses(json_response)
    forecast_by_location = {}
    max_daily_data_points = []
    alert_starting_id = 'A'
    all_alerts = Set.new

    forecast_id = 1
    set_current_fcst = true

    json_response.each do |location, response|
      alerts_for_location = {}
      currently = daily = nil
      next if response.blank?

      daily_summary = response['description'] || ''
      d_forecast = response[DAILY_FORECAST]
      unless d_forecast.blank?

=begin
        # current forecast is day 0 forecast
        c_forecast = d_forecast.shift
        unless c_forecast.blank?
          ts = Forecast::Data.new(make_compatible(c_forecast))
          currently = Forecast::TimeSeriesSummary.new_currently(
            c_forecast['description'],
            c_forecast['icon'],
            ts
          )
        end
=end

        daily_data = (d_forecast || []).map do |hsh|
          Forecast::Data.new(make_compatible(hsh))
        end

        if daily_data.size > max_daily_data_points.size
          max_daily_data_points = daily_data.map { |hd| hd.time }
        end

        daily = Forecast::TimeSeriesSummary.new_daily(
            response['description'],
            response['icon'],
            daily_data
        )
      end

      Rails.logger.debug "ALERTS : " + response[ALERTS].inspect
      (response[ALERTS] || []).each do |alert_hash|
        alert = Forecast::Alert.new(make_compatible_for_alert(alert_hash))
        if all_alerts.include?(alert)
          alert.alert_id = all_alerts.first { |a| a == alert }.alert_id
          alerts_for_location[alert.alert_id] = alert
        else
          alert.alert_id = alert_starting_id
          alerts_for_location[alert_starting_id] = alert
          all_alerts << alert
          alert_starting_id = alert_starting_id.next
        end
      end

      hsh = {
          forecast_id: forecast_id,
          location: location,
          currently: currently,
          daily: daily,
          daily_summary: daily_summary,
          alerts: alerts_for_location,
      }

      forecast_by_location[location] = Forecast::Detail.new hsh
      forecast_id += 1
    end
    return all_alerts, forecast_by_location, max_daily_data_points
  end

  #######
  private
  #######

  def self.make_compatible(hsh)
    return {} if hsh.blank?
    hsh['time'] = hsh.delete('datetimeEpoch')
    hsh['summary'] = hsh.delete('description')

    hsh['precipProbability'] = hsh.delete('precipprob')
    hsh['precipAmount'] = hsh.delete('precip')
    hsh['temperature'] = hsh.delete('temp')
    hsh['apparentTemperature'] = hsh.delete('feelslike')
    hsh['dewPoint'] = hsh.delete('dew')


    hsh['temperatureHigh'] = hsh.delete('tempmax')
    hsh['temperatureLow'] = hsh.delete('tempmin')

    hsh['sunsetTime'] = hsh.delete('sunsetEpoch')
    hsh['sunriseTime'] = hsh.delete('sunriseEpoch')

    hsh['cloudCover'] = hsh.delete('cloudcover')

    hsh
  end


  # MY_ATTRIBUTES = :title, :regions, :severity, :time, :expires, :description, :uri, :alert_id
  def self.make_compatible_for_alert(hsh)
    return {} if hsh.blank?
    hsh['title'] = hsh.delete('event')
    hsh['expires'] = hsh.delete('endsEpoch')
    hsh['uri'] = hsh.delete('link')
    hsh['description'] = (hsh['description'] || '').humanize

    hsh
  end

end
end
