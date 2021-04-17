module Forecast
module Client
class Base
  attr_reader :locations

  def get_forecast
    raise NotImplementedError
  end

  def self.new_ds_client(locations)
    DarkSky.new locations
  end

  def self.new_vc_client(locations)
    VisualCrossing.new locations
  end

  def self.new_mock_client(locations)
    DarkSkyMock.new locations
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
