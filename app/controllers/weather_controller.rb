class WeatherController < ApplicationController
  before_action :set_by_region_flag
  skip_before_action :authenticate_user!, only: [:vc, :weather_json]

  def index
    params['client_type'] = Weather::DARK_SKY_CLIENT
    @weather = Weather.find(params)
    @forecast_summary = @weather.get_forecast
    @forecast_type = @weather.type
  end

  def by_region
    params['client_type'] = Weather::DARK_SKY_CLIENT
    @weather = Weather.find_by_region(params)
    @forecast_summary = @weather.get_forecast
    @forecast_type = @weather.type
    @by_region = true
  end

  def vc
    params['client_type'] = Weather::VC_CLIENT
    @weather = Weather.find_by_region(params)
    @forecast_summary = @weather.get_forecast
    @forecast_type = @weather.type
    @by_region = true
  end

  def weather_json
    weather = Weather.find_by_region(params)
    respond_to do |format|
      unless weather.blank?
        results = {
          locations: weather,
          forecast_summary: weather.get_forecast,
          forecast_type: weather.type
        }
        format.json { render json: results, status: :ok }
      else
        format.json { render json: {errors: :not_found}, status: :not_found }
      end
    end

    (weather || {}).to_json
  end

  #######
  private
  #######

  def set_by_region_flag
    @by_region =  false # defaults to false
  end

end
