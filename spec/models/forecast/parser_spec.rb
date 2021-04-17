require 'rails_helper'

RSpec.describe Forecast::Parser, type: :model do

  context "#dark_sky_parser" do
    it "should parse valid input" do
      location = LatitudeLongitudeByRegion.instance.convert(['leavenworth'])
      client = Forecast::Client::Base.new_ds_mock_client(location)
      service_response = client.setup_raw_response(location)

      forecast_summary = Forecast::Parser.dark_sky_parser(service_response, nil)
      details = forecast_summary.forecasts.values.first

      expect(details.location).to eq(location.first)
      expect(details.currently.summary).to eq('Clear')

    end
  end

end
