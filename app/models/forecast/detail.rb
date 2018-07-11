module Forecast
class Detail

  attr_reader :location, :currently, :daily, :hourly
  def initialize(location, currently, daily, hourly)
    @location = location
    @currently = currently
    @daily = daily
    @hourly = hourly
  end

end
end
