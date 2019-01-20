class WeatherController < ApplicationController
  def index
    make_fake_call = true
    @weather = Weather.all(params)
    @forecast_summary = @weather.get_forecast
    google_map = Maps::GoogleMapClient.new @forecast_summary.forecasts
    @google_image_src = google_map.image_src
  end

end
