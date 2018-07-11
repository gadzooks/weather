module Forecast
class TimeSeriesSummary
  attr_reader :type, :summary, :icon, :data

  Type.all.each do |type|
    self.define_singleton_method("new_#{type}") do |summary, icon, data|
      data = [data] unless data.respond_to?(:each)
      new(type, summary, icon, data)
    end
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
