module Forecast
class Parser
  CURRENT_FORECAST = 'currently'
  DAILY_FORECAST = 'daily'
  ALERTS = 'alerts'

  def self.dark_sky_parser(json_response)
    return {} if json_response.blank?

    forecast_by_location = {}
    max_daily_data_points = []
    all_alerts = Hash.new { |h, k| h[k] = [] }

    json_response.each do |location, response|
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

      alerts = (response[ALERTS] || []).map { |alert| Forecast::Alert.new(alert) }
      alerts.each do |alert|
        all_alerts[alert] << location
      end

      hsh = {
        location: location,
        currently: currently,
        daily: daily,
        daily_summary: daily_summary,
        alerts: alerts,
      }

      forecast_by_location[location] = Forecast::Detail.new hsh
    end

    Rails.logger.debug 'parsing forecast for locations : '
    Rails.logger.debug forecast_by_location.keys.inspect
    Forecast::Summary.new(forecast_by_location, max_daily_data_points, all_alerts)
  end

end
end
