require 'rails_helper'

RSpec.describe Forecast::Parser, type: :model do

  context "#dark_sky_parser" do
    it "should parse valid input" do
      location = LatitudeLongitude.instance.convert(['seattle'])
      service_response = DarkSky::Client.fake_api_call(location)

      forecast_summary = Forecast::Parser.dark_sky_parser(service_response)
      details = forecast_summary.forecasts.values.first

      expect(details.location).to eq(location.first)
      expect(details.currently.summary).to eq('Clear')

    end
  end

end
