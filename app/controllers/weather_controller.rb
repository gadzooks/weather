class WeatherController < ApplicationController
  def index
    @weather = Weather.new
    @forecast_summary = @weather.get_forecast
  end

end
