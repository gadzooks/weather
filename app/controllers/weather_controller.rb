class WeatherController < ApplicationController
  def index
    make_fake_call = true
    if(params[:test].blank? && !Rails.env.production?)
       make_fake_call = true # in non prod by default we will make FAKE service calls
    else
      make_fake_call = (params[:test].to_s == 'true')
    end
    @weather = Weather.all(!make_fake_call)
    @forecast_summary = @weather.get_forecast
  end
end
