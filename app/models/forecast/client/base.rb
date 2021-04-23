module Forecast
module Client
class Base
  include Typhoeus
  attr_reader :locations

  def get_forecast
    raise NotImplementedError
  end

  def create_request_for_location(location)
    raise NotImplementedError
  end

  def self.new_ds_client(locations)
    DarkSky.new locations
  end

  def self.new_vc_client(locations)
    VisualCrossing.new locations
  end

  def self.new_ds_mock_client(locations)
    DarkSkyMock.new locations
  end

  def self.new_vc_mock_client(locations)
    VisualCrossingMock.new locations
  end

  def get_forecast
    hydra = Hydra.new
    requests = {}
    locations.each do |loc|
      next if loc.blank?
      req = create_request_for_location(loc)
      requests[loc] = req
      hydra.queue req
    end

    hydra.run

    responses = {}
    errors = {}

    requests.each do |location, r|
      Rails.logger.info "Response code for #{location.name} is : " +
        r.response.response_code.to_s

      # FIXME handle JSON parse errors
      if r.response.response_code != 200
        if r.try(:response).try(:body)
          body = r.response.body
          errors[location] = JSON.parse body
        else
          errors[location] = { code: nil, error: 'Unknown error while calling API' }
        end
      else
        if r.response.body
          body = r.response.body
          responses[location] = JSON.parse body
          # write_dark_sky_api_results_to_files(location, responses)
        else
          responses[location] = {}
        end
      end
    end

    [responses, errors]
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
