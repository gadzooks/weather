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
    requests.each do |location, r|
      Rails.logger.debug "Response code for #{location.name} is : " +
        r.response.response_code.to_s

      # FIXME handle JSON parse errors
      next unless r.response.response_code == 200

      if r.response.body
        body = r.response.body
        responses[location] = JSON.parse body
        #filename = location.name.gsub(/ /,'').upcase + '.json'
        #File.open(filename, 'w') { |f| f.write responses[location].to_json }
      else
        responses[location] = {}
      end
    end

    Parser.dark_sky_parser responses
  end


  #######
  private
  #######
  # FIXME use different api keys for devo and prod
  API_KEY = Rails.application.credentials.dark_sky[:api_key]
  BASE_URL = "https://api.darksky.net/forecast/#{API_KEY}"
  EXCLUDE_BLOCK = "?exclude=minutely,hourly"

  def create_dark_sky_request(loc)
    url = BASE_URL + '/' +  loc.latitude.to_s + ',' + loc.longitude.to_s +
        EXCLUDE_BLOCK

    Request.new(url, cache_ttl: 10.minutes)
  end


end
end
end
