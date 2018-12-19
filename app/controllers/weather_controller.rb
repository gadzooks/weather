class WeatherController < ApplicationController
  def index
    make_fake_call = (params[:test].to_s == 'true')
    @weather = Weather.all(!make_fake_call)
    @forecast_summary = @weather.get_forecast
  end
end
