require 'rails_helper'

RSpec.describe Forecast::VcParser, type: :model do

  context "visual_crossing_parser" do
    LatitudeLongitudeByRegion.instance.all_places.each do |location|
      it "should parse valid input for #{location}" do
        STDERR.puts "vc parsing for location : #{location}"
        location = LatitudeLongitudeByRegion.instance.convert([location])
        client = Forecast::Client::Base.new_vc_mock_client(location)
        service_response = client.setup_raw_response(location)

        forecast_summary = Forecast::VcParser.parse(service_response, nil)
        details = forecast_summary.forecasts.values.first

        expect(details.location).to eq(location.first)
        STDERR.puts "currently is " + details.currently.inspect
        expect(details.currently.summary).to eq('Clear conditions throughout the day.')

      end
    end
  end

end
