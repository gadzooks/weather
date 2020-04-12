module Forecast
module Client
class DarkSky < Base
  include Typhoeus

  # https://api.darksky.net/forecast/[key]/[latitude],[longitude]
  def get_forecast
    Rails.logger.debug "Getting forecast for : " + @locations.inspect

    hydra = Hydra.new
    requests = {}
    locations.each do |loc|
      next if loc.blank?
      url = BASE_URL + '/' +  loc.latitude.to_s + ',' + loc.longitude.to_s +
        EXCLUDE_BLOCK
      req = create_dark_sky_request(loc)
      requests[loc] = req
      hydra.queue req
    end

    hydra.run

    responses = {}
    errors = {}

    requests.each do |location, r|
      Rails.logger.debug "Response code for #{location.name} is : " +
        r.response.body

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

    Parser.dark_sky_parser(responses, errors)
  end


  #######
  private
  #######
  # FIXME use different api keys for devo and prod
  API_KEY = Rails.application.credentials.dark_sky[:api_key]
  BASE_URL = "https://api.darksky.net/forecast/#{API_KEY}"
  EXCLUDE_BLOCK = "?exclude=minutely,hourly"

  # useful for debugging and using in mock service
  def write_dark_sky_api_results_to_files(location, responses)
    filename = 'tmp/' + location.name.gsub(/ /,'').upcase + '.json'
    filename.downcase!
    puts "Writing to #{filename}"
    File.open(filename, 'w') { |f| f.write responses[location].to_json }
  end

  def create_dark_sky_request(loc)
    url = BASE_URL + '/' +  loc.latitude.to_s + ',' + loc.longitude.to_s +
        EXCLUDE_BLOCK

    Request.new(url, cache_ttl: 10.minutes)
  end


end
end
end
