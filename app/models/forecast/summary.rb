module Forecast
  Summary = Struct.new(:forecasts, :daily_times) do
    def daily_values_for(location, weather_property)
      forecast_details_for_loc = forecasts[location]
      (daily_times || []).map do |time|
        forecast_details_for_loc.daily(time).send(weather_property.to_sym)
      end
    end
  end
end
