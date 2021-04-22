module Forecast
module Client
class VisualCrossingMock < Base

  def get_forecast
    Rails.logger.debug 'Making FAKE api call'

    # randomize returning the results a bit
    selected_locations = @locations[0..rand(@locations.size)]

    raw_response = setup_raw_response(selected_locations)
    raw_response
  end

  def setup_raw_response(selected_locations)
    responses = {}

    selected_locations.each do |loc|
      next if loc.blank?
      filename = "spec/models/api/vc/response/vc-#{loc.name}.json"
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
