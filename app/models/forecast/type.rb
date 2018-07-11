module Forecast
class Type < Enum::Base
  values :currently, :daily, :hourly
end
end
