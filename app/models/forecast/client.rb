module Forecast
class Client

  attr_reader :locations
  def initialize(locations)
    @locations = locations
    self
  end

  def get_forecast
    Rails.logger.debug "Getting forecast for : " + @locations.inspect
    @json_response = DarkSky::Client.get_forecast_by_location(@locations)
    #Rails.logger.debug @json_response.inspect

    Parser.dark_sky_parser(@json_response)
  end

end
end
