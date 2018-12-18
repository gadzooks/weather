module Forecast
class Data
  TS_ATTRIBUTES = [:time, :summary, :icon, :precipIntensity, :precipProbability,
    :temperature, :apparentTemperature, :dewPoint, :timeSeriesType,
    :temperatureHigh, :temperatureHighTime, :temperatureLow, :temperatureLowTime,
    :sunsetTime, :sunriseTime, :visibility, :cloudCover
  ]
  attr_reader *TS_ATTRIBUTES

  def initialize(input)
    unless input.blank?
      TS_ATTRIBUTES.each do |ivar|
        ivar = ivar.to_s
        method_name = "#{ivar}="
        # send is safe here since we are iterating over TS_ATTRIBUTES
        send("#{ivar}=", input[ivar])
      end

      # FIXME handle parse errors
      #@time = DateTime.strptime(@time.to_s,'%s') if @time
      @time = Time.at(@time) if @time

      @visibility = @visibility.to_i * 10
      @cloudCover = (@cloudCover.to_f * 100).round
    end
    self
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
  attr_writer *TS_ATTRIBUTES
  DESC_REGEXP = /^\w+(-\w+)?/

end
end
