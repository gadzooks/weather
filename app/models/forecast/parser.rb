module Forecast
class Parser
  CURRENT_FORECAST = 'currently'
  DAILY_FORECAST = 'daily'
  HOURLY_FORECAST = 'hourly'

  def self.dark_sky_parser(json_response)
    return {} if json_response.blank?

    forecast_by_location = {}

    max_hourly_data_points = []
    max_daily_data_points = []
    json_response.each do |location, response|
      currently = hourly = daily = nil
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

      h_forecast = response[HOURLY_FORECAST]
      unless h_forecast.blank?
        hourly_data = (h_forecast['data'] || []).map do |hsh|
          Forecast::Data.new(hsh)
        end

        if hourly_data.size > max_hourly_data_points.size
          max_hourly_data_points = hourly_data.map { |hd| hd.time }
        end

        hourly = Forecast::TimeSeriesSummary.new_hourly(
          h_forecast['summary'],
          h_forecast['icon'],
          hourly_data
        )
      end

      d_forecast = response[DAILY_FORECAST]
      unless d_forecast.blank?
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

      hsh = {
        location: location,
        currently: currently,
        daily: daily,
        hourly: hourly,
      }

      forecast_by_location[location] = Forecast::Detail.new hsh
    end

    Rails.logger.debug 'parsing forecast for locations : '
    Rails.logger.debug forecast_by_location.keys.inspect
    Forecast::Summary.new(forecast_by_location, max_hourly_data_points,
                          max_daily_data_points)
  end

end
end
