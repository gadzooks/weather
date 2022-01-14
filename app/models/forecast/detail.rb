module Forecast
class Detail
  attr_reader :location, :max_daily_data_points, :daily_summary, :alerts,
    :forecast_id, :alert_lasts_till

  def initialize(hsh)
    @forecast_id = hsh[:forecast_id] || '-'
    @location = hsh[:location]
    @currently = hsh[:currently]
    @daily = hsh[:daily]
    @max_daily_data_points = hsh[:max_daily_data_points]
    @daily_summary = hsh[:daily_summary]
    @alerts = hsh[:alerts] || []
    @alert_lasts_till = hsh[:alert_lasts_till] || Time.at(2000)
  end

  def currently
    @currently.timeseries
  end

  def daily(index = nil)
    @daily.timeseries(index)
  end

  def daily_time_for(index)
    if @daily
      h_data = @daily.values.find { |daily_data| daily_data.daily(index) }
      return h_data.daily(index)
    else
      nil
    end
  end

  def region
    LatitudeLongitudeByRegion.instance.region_for_location(@location)
  end

end
end
