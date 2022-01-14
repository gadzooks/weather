require 'rails_helper'

RSpec.describe Forecast::VcParser, type: :model do

  context "visual_crossing_parser" do
    LatitudeLongitudeByRegion.instance.all_places.each do |location|
      it "should parse valid input for #{location}" do
        # STDERR.puts "vc parsing for location : #{location}"
        location = LatitudeLongitudeByRegion.instance.convert([location])
        client = Forecast::Client::Base.new_vc_client(location, false)
        service_response = client.setup_raw_response(location)

        forecast_summary = Forecast::VcParser.parse(service_response, nil)
        details = forecast_summary.forecasts.values.first

        if details # some locations like san juan dont have the response files
          expect(details.location).to eq(location.first)
          # STDERR.puts "daily is " + details.daily.inspect
          expect(details.daily.values.first.summary).to eq('Clear conditions throughout the day.')
        end

      end
    end

    it "should parse alerts correctly" do
        location = LatitudeLongitudeByRegion.instance.convert(['snowqualmie_pass'])
        # STDERR.puts "vc parsing for location : #{location}"
        client = Forecast::Client::Base.new_vc_client(location, false)
        service_response = client.setup_raw_response(location)

        forecast_summary = Forecast::VcParser.parse(service_response, nil)
        details = forecast_summary.forecasts.values.first

        expect(details.location).to eq(location.first)
        # STDERR.puts "daily is " + details.daily.inspect
        expect(details.daily.values.first.summary).to eq('Clear conditions throughout the day.')


    end

    it "should parse planetory info correctly" do
        location = LatitudeLongitudeByRegion.instance.convert(['snowqualmie_pass'])
        # STDERR.puts "vc parsing for location : #{location}"
        client = Forecast::Client::Base.new_vc_client(location, false)
        service_response = client.setup_raw_response(location)

        forecast_summary = Forecast::VcParser.parse(service_response, nil)
        planetory_info = forecast_summary.planetory_info

        expect(planetory_info.sunriseEpoch.to_i).to eq(1618665158)
        expect(planetory_info.sunsetEpoch.to_i).to eq(1618714704)
        expect(planetory_info.moonPhases).to eq([0.12, 0.16, 0.21, 0.26, 0.31, 0.36, 0.41, 0.45, 0.48, 0.5, 0.5, 0.52, 0.54, 0.58, 0.63])
    end
  end

end
