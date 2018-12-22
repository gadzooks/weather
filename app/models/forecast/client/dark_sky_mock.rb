module Forecast
module Client
class DarkSkyMock < Base

  def get_forecast
    Rails.logger.debug 'Making FAKE api call'

    # randomize returning the results a bit
    selected_locations = @locations[0..rand(@locations.size)]

    Rails.logger.debug "Calling for : #{selected_locations.inspect}"
    raw_response = setup_raw_response(selected_locations)
    Parser.dark_sky_parser raw_response
  end

  def setup_raw_response(selected_locations)
    responses = {}

    selected_locations.each do |loc|
      next if loc.blank?
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

end
end
end
