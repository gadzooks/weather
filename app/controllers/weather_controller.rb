class WeatherController < ApplicationController
  def index
    @weather = Weather.new :paris
  end

  def current
  end
end
