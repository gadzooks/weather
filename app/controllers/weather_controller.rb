class WeatherController < ApplicationController
  def index
    force_load = params[:prod] || 'true'
    @call_weather_client = force_load.downcase == 'true'
    @weather = Weather.all(@call_weather_client)
    @forecast_summary = @weather.get_forecast
  end

end
