class WeatherController < ApplicationController
  def index
    @weather = Weather.find(params)
    @forecast_summary = @weather.get_forecast
    google_map = Maps::GoogleMapClient.new @forecast_summary.forecasts
    @google_image_src = google_map.image_src
  end

  def by_region
    @weather = Weather.find_by_region(params)
    @forecast_summary = @weather.get_forecast
    @google_image_src = nil
  end

end
