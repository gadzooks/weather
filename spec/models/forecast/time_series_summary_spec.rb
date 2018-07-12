require 'rails_helper'

RSpec.describe Forecast::TimeSeriesSummary, type: :model do

  context "initialize object" do
    it "should create currently forecast model" do
      summary = 'cloudy'
      icon = 'cloudy-day'
      data = 'foo'
      ts = Forecast::TimeSeriesSummary.new_currently(
        summary,
        icon,
        data
      )

      expect(ts.type).to eq(Forecast::Type.enum(:currently))
      expect(ts.summary).to eq(summary)
      expect(ts.icon).to eq(icon)
      expect(ts.data).to eq(data)
    end

  end
end
