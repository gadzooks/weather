module Forecast
class Detail

  attr_reader :location, :max_hourly_data_points, :max_daily_data_points
  def initialize(hsh)
    @location = hsh[:location]
    @currently = hsh[:currently]
    @daily = hsh[:daily]
    @hourly = hsh[:hourly]
    @max_daily_data_points = hsh[:max_daily_data_points]
    @max_hourly_data_points = hsh[:max_hourly_data_points]
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

  def hourly_time_for(index)
    if @hourly
      h_data = @hourly.values.find { |hourly_data| hourly_data.hourly(index) }
      return h_data.hourly(index)
    else
      nil
    end
  end

  def daily_time_for(index)
    if @daily
      h_data = @daily.values.find { |daily_data| daily_data.daily(index) }
      return h_data.daily(index)
    else
      nil
    end
  end

end
end
