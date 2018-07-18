module DarkSky
class Client
  include Typhoeus

  # FIXME use different api keys for devo and prod
  # FIXME set up mock for rspec
  API_KEY="3b3556692fd048477a0decc9b6911ebe"
  BASE_URL = "https://api.darksky.net/forecast/#{API_KEY}"
  EXCLUDE_BLOCK = "?exclude=minutely"

  # FIXME better ways to store secret key
  #https://stackoverflow.com/questions/26498357/how-to-use-secrets-yml-for-api-keys-in-rails-4-1
  #https://www.engineyard.com/blog/encrypted-rails-secrets-on-rails-5.1
  def self.get_forecast_by_location(locations)
    if Rails.env.production?
      actual_api_call(locations)
    else
      fake_api_call(locations)
    end
  end

  def self.fake_api_call(locations)
    Rails.logger.debug 'Making FAKE api call'
    responses = {}
    locations.each do |loc|
      if rand(3) == 1
        responses[loc] = {}
        next
      end
      filename = "spec/models/api/response/#{loc.name}.json"
      filename = filename.gsub(/ /,'')
      if File.exists? filename
        File.open(filename) do |fh|
          responses[loc] = JSON.parse fh.read
        end
      end
    end

    responses
  end

  # https://api.darksky.net/forecast/[key]/[latitude],[longitude]
  def self.actual_api_call(locations)
    hydra = Hydra.new
    requests = {}
    locations.each do |loc|
      url = BASE_URL + '/' +  loc.latitude.to_s + ',' + loc.longitude.to_s +
        EXCLUDE_BLOCK
      req = Request.new url
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

    responses
  end

end
end
