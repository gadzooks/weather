require_dependency 'initialize_from_hash'
module Forecast
class Data
  include InitializeFromHash
  MY_ATTRIBUTES = [:time, :summary, :icon, :precipIntensity, :precipProbability,
    :temperature, :apparentTemperature, :dewPoint, :timeSeriesType,
    :temperatureHigh, :temperatureHighTime, :temperatureLow, :temperatureLowTime,
    :sunsetTime, :sunriseTime, :visibility, :cloudCover
  ]
  attr_reader *MY_ATTRIBUTES

  def initialize(input)
    unless input.blank?
      setup_instance_variables input

      # FIXME handle parse errors
      #@time = DateTime.strptime(@time.to_s,'%s') if @time
      @time = Time.at(@time) if @time

      @visibility = @visibility.to_i * 10
      @cloudCover = (@cloudCover.to_f * 100).round
    end
  end

  def desc
    unless @icon.blank?
      r = DESC_REGEXP.match @icon
      return r[0] if r
    end
    ''
  end

  #######
  private
  #######
  attr_writer *MY_ATTRIBUTES
  DESC_REGEXP = /^\w+(-\w+)?/

end
end
