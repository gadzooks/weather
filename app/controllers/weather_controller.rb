class WeatherController < ApplicationController
  def index
    make_fake_call = true
    @weather = Weather.all(params)
    @forecast_summary = @weather.get_forecast
  end
end
