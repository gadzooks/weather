module Forecast
module Client
class DarkSky < Base

  # https://api.darksky.net/forecast/[key]/[latitude],[longitude]
  #######
  protected
  #######
  # FIXME use different api keys for devo and prod
  API_KEY = ENV['DARK_SKY_API_KEY']
  BASE_URL = "https://api.darksky.net/forecast/#{API_KEY}"
  EXCLUDE_BLOCK = "?exclude=minutely,hourly"

  # useful for debugging and using in mock service
  def write_dark_sky_api_results_to_files(location, responses)
    filename = 'tmp/' + location.name.gsub(/ /,'').upcase + '.json'
    filename.downcase!
    puts "Writing to #{filename}"
    File.open(filename, 'w') { |f| f.write responses[location].to_json }
  end

  def create_request_for_location(loc)
    url = BASE_URL + '/' +  loc.latitude.to_s + ',' + loc.longitude.to_s +
        EXCLUDE_BLOCK

    Request.new(url, cache_ttl: 6.hours)
  end


end
end
end
