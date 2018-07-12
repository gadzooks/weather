module Forecast
class TimeSeriesSummary
  attr_reader :type, :summary, :icon, :data

  Type.all.each do |type|
    self.define_singleton_method("new_#{type}") do |summary, icon, data|
      new(type, summary, icon, data)
    end
  end

  def timeseries(time = nil)
    time.nil? ? @data : @data[time]
  end

  #######
  private
  #######
  def initialize(type, summary, icon, data)
    @type = type
    @summary = summary
    @icon = icon
    @data = data
  end

end
end
