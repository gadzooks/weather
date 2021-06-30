module Forecast
module Client
class Base
  include Typhoeus
  attr_reader :locations, :make_actual_call, :type

  DARK_SKY_CLIENT = 'DARK_SKY_CLIENT'
  VC_CLIENT       = 'VC_CLIENT'
  DS_MOCK_CLIENT  = 'DS_MOCK_CLIENT'
  VC_MOCK_CLIENT  = 'VC_MOCK_CLIENT'

  def self.new_ds_client(locations, make_actual_call)
    new_client(DARK_SKY_CLIENT, locations, make_actual_call)
  end

  def self.new_vc_client(locations, make_actual_call)
    new_client(VC_CLIENT, locations, make_actual_call)
  end

  def self.new_client(type, locations, make_actual_call = false)
    client = nil
    if type == DARK_SKY_CLIENT
      if make_actual_call
        client = DarkSky.new(locations, Forecast::Parser)
      else
        client = DarkSkyMock.new(locations, Forecast::Parser)
      end
    else
      if make_actual_call
        client = VisualCrossing.new(locations, Forecast::VcParser)
      else
        client = VisualCrossingMock.new(locations, Forecast::VcParser)
      end
    end
  end

  def get_forecast
    hydra_options = {}
    if max_concurrency != -1
      hydra_options[:max_concurrency] = max_concurrency
    end
    Rails.logger.info "hydra_options are : #{hydra_options.inspect}"
    hydra = Hydra.new(hydra_options)
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
          begin
            msg = JSON.parse body
            errors[location] = msg
          rescue => e
            errors[location] = { 'code' => r.response.response_code,
                                 'error' => body }
          end
        else
          errors[location] = { 'code' => nil, 'error' => 'Unknown error while calling API' }
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

    @parser.parse(responses, errors)
  end

  #########
  protected
  #########

  # each subclass needs to implement this method
  def create_request_for_location(location)
    raise NotImplementedError
  end

  # can be overridden in base class. -1 means max possible
  def max_concurrency
    -1
  end

  #######
  private
  #######

  def initialize(locations, parser)
    @locations = locations
    @parser = parser
  end

end
end
end
