module Forecast
module Client
class VisualCrossing < Base
  include Typhoeus

  # https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/38.96972,-77.38519?key=YOUR_KEY&include=obs,fcst

  #########
  protected
  #########

  def create_request_for_location(loc)
    url = BASE_URL + '/' +  loc.latitude.to_s + ',' + loc.longitude.to_s +
        EXCLUDE_BLOCK

    Request.new(url, cache_ttl: 6.hours)
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


end
end
end
