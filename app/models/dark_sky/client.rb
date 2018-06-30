module DarkSky
class Forecast
  include Typhoeus

  API_KEY="3b3556692fd048477a0decc9b6911ebe"

  remote_defaults
    :on_success => lambda {|response| JSON.parse(response.body)},
    :on_failure => lambda {|response| puts "error code: #{response.code}"},
      #FIXME handle failure better
    :base_uri => "https://api.darksky.net/forecast/#{API_KEY}"


end
end
