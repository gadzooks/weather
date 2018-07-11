class WeatherController < ApplicationController
  def index
    @weather = Weather.new
    @forecast = @weather.get_forecast
  end

end
