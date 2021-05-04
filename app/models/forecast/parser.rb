module Forecast
class Parser
  CURRENT_FORECAST = 'currently'
  DAILY_FORECAST = 'daily'
  ALERTS = 'alerts'

  def self.parse(json_response, errors)
    json_response ||= {}

    forecast_by_location = {}
    max_daily_data_points = []
    alert_starting_id = 'A'
    all_alerts = Set.new
    planetory_info = nil

    forecast_id = 1
    json_response.each do |location, response|
      alerts_for_location = {}
      currently = daily = nil
      next if response.blank?

      c_forecast = response[CURRENT_FORECAST]
      unless c_forecast.blank?
        ts = Forecast::Data.new(c_forecast)
        currently = Forecast::TimeSeriesSummary.new_currently(
            c_forecast['summary'],
            c_forecast['icon'],
            ts
        )
      end

      daily_summary = ''
      d_forecast = response[DAILY_FORECAST]
      unless d_forecast.blank?
        daily_summary = d_forecast['summary'] || ''

        unless planetory_info
          planetory_info = parse_planetory_info(d_forecast['data'])
        end


        daily_data = (d_forecast['data'] || []).map do |hsh|
          Forecast::Data.new(hsh)
        end

        if daily_data.size > max_daily_data_points.size
          max_daily_data_points = daily_data.map { |hd| hd.time }
        end

        daily = Forecast::TimeSeriesSummary.new_daily(
            d_forecast['summary'],
            d_forecast['icon'],
            daily_data
        )
      end

      (response[ALERTS] || []).each do |alert_hash|
        alert = Forecast::Alert.new(alert_hash)
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

    Forecast::Summary.new(planetory_info, forecast_by_location, max_daily_data_points, all_alerts, errors)
  end

  def self.parse_planetory_info(forecasts)
    forecasts ||= []
    unless forecasts.blank?
      hsh = {}
      hsh['sunriseEpoch'] = forecasts.first['sunriseTime']
      hsh['sunsetEpoch'] = forecasts.first['sunsetTime']

      moonPhases = forecasts.map do |forecast|
        forecast['moonPhase']
      end

      hsh['moonPhases'] = moonPhases
      Forecast::Planetory.new(hsh)
    end
  end


end
end
