module Forecast
module Client
class Base
  attr_reader :locations

  def get_forecast
    raise NotImplementedError
  end

  def self.new_client(call_real_service, locations)
    if call_real_service
      DarkSky.new locations
    else
      DarkSkyMock.new locations
    end
  end

  #######
  private
  #######

  def initialize(locations)
    @locations = locations
  end

end
end
end
