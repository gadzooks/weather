require 'rails_helper'

RSpec.describe Forecast::TimeSeries, type: :model do

  context "initialize object" do
    it "should setup object with valid input" do
      txt = '{
    "summary": "No precipitation throughout the week, with high temperatures rising to 89°F on Monday.",
    "icon": "clear-day",
    "data": [
      {
        "time": 1531206000,
        "summary": "Mostly cloudy until evening.",
        "icon": "partly-cloudy-day",
        "uvIndex": 6,
        "uvIndexTime": 1531252800,
        "visibility": 10,
        "ozone": 327.83,
        "temperatureMin": 58.12,
        "temperatureMinTime": 1531231200,
        "temperatureMax": 71.29,
        "temperatureMaxTime": 1531267200,
        "apparentTemperatureMin": 58.12,
        "apparentTemperatureMinTime": 1531231200,
        "apparentTemperatureMax": 71.29,
        "apparentTemperatureMaxTime": 1531267200
      }
      ]}'

      j = JSON.parse txt

      ts = Forecast::TimeSeries.new j

      expect(ts.icon).to eq('clear-day')
    end
  end

end
