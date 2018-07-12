module Forecast
class Detail

  attr_reader :location
  def initialize(location, currently, daily, hourly)
    @location = location
    @currently = currently
    @daily = daily
    @hourly = hourly
  end

  def currently
    @currently.timeseries
  end

  def daily
    @daily.timeseries
  end

  def hourly
    @hourly.timeseries
  end

end
end
