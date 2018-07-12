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

  def daily(index = nil)
    @daily.timeseries(index)
  end

  def hourly(index = nil)
    @hourly.timeseries(index)
  end

end
end
