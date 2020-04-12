module Forecast
  Summary = Struct.new(:forecasts, :daily_times, :alerts, :errors) do
    def blank?
      forecasts.blank?
    end

    def daily_values_for(location, weather_property)
      forecast_details_for_loc = forecasts[location]
      (daily_times || []).map do |time|
        forecast_details_for_loc.daily(time).send(weather_property.to_sym)
      end
    end

    def alerts_for(location)
      alerts[location]
    end
  end
end
