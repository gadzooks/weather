class WeatherController < ApplicationController
  before_action :set_by_region_flag

  def index
    @weather = Weather.find(params)
    @forecast_summary = @weather.get_forecast
  end

  def by_region
    @weather = Weather.find_by_region(params)
    @forecast_summary = @weather.get_forecast
    @by_region = true
    @google_image_src = nil
  end

  #######
  private
  #######

  def set_by_region_flag
    @by_region =  false # defaults to false
  end

end
