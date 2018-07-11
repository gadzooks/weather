module Forecast
class Parser
  CURRENT_FORECAST = 'currently'
  DAILY_FORECAST = 'daily'
  HOURLY_FORECAST = 'hourly'

  def self.dark_sky_parser(json_response)
    return {} if json_response.blank?

    forecast_by_location = {}

    json_response.each do |location, response|
      currently = hourly = daily = nil
      next if response.blank?

      c_forecast = response[CURRENT_FORECAST]
      unless c_forecast.blank?
        ts = Forecast::TimeSeries.new(c_forecast)
        currently = Forecast::TimeSeriesSummary.new_currently(
          c_forecast['summary'],
          c_forecast['icon'],
          ts
        )
      end

      h_forecast = response[HOURLY_FORECAST]
      unless h_forecast.blank?
        hourly_data = (h_forecast['data'] || []).map do |hsh|
          Forecast::TimeSeries.new(hsh)
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
          Forecast::TimeSeries.new(hsh)
        end
        daily = Forecast::TimeSeriesSummary.new_daily(
          d_forecast['summary'],
          d_forecast['icon'],
          daily_data
        )
      end

      forecast_by_location[location] = Forecast::Detail.new(
        location,
        currently,
        daily,
        hourly
      )
    end

    forecast_by_location
  end

end
end
