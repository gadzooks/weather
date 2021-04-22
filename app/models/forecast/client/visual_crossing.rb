module Forecast
module Client
class VisualCrossing < Base
  include Typhoeus

  # https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/38.96972,-77.38519?key=YOUR_KEY&include=obs,fcst
  def get_forecast
    Rails.logger.debug "Getting forecast for : " + @locations.inspect

    hydra = Hydra.new
    requests = {}
    locations.each do |loc|
      next if loc.blank?
      req = create_dark_sky_request(loc)
      requests[loc] = req
      hydra.queue req
    end

    hydra.run

    responses = {}
    errors = {}

    requests.each do |location, r|
      Rails.logger.debug "Response code for #{location.name} is : " +
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
          write_dark_sky_api_results_to_files(location, responses, 'vc')
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
  API_KEY = ENV["VISUAL_CROSSING_API_KEY"]
  # https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/38.96972,-77.38519?key=YOUR_KEY&include=obs,fcst
  BASE_URL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline"
  EXCLUDE_BLOCK = "?key=#{API_KEY}&include=obs,fcst,alerts"

  # useful for debugging and using in mock service
  def write_dark_sky_api_results_to_files(location, responses, prefix = 'ds')
    filename = "tmp/#{prefix}-" + location.name.gsub(/ /,'').upcase + '.json'
    filename.downcase!
    puts "Writing to #{filename}"
    File.open(filename, 'w') { |f| f.write responses[location].to_json }
  end

  def create_dark_sky_request(loc)
    url = BASE_URL + '/' +  loc.latitude.to_s + ',' + loc.longitude.to_s +
        EXCLUDE_BLOCK

    Request.new(url, cache_ttl: 6.hours)
  end


end
end
end
