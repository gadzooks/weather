module Forecast
class TimeSeriesSummary
  attr_reader :type, :summary, :icon, :data

  Type.all.each do |type|
    self.define_singleton_method("new_#{type}") do |summary, icon, data|
      new(type, summary, icon, data)
    end
  end

  def timeseries(time = nil)
    time ? @data[time] : @data
  end

  #######
  private
  #######
  def initialize(type, summary, icon, data)
    @type = type
    @summary = summary
    @icon = icon
    @data = nil
    if (type == Forecast::Type.enum(:currently))
      @data = data
    else
      @data = {}
      (data || []).each do |d|
        @data[d.time] = d
      end
    end
  end

end
end
