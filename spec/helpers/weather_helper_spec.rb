require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the WeatherHelper. For example:
#
# describe WeatherHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe WeatherHelper, type: :helper do
  context 'moon_phase_numeric' do
    it "should compute valid number for all moon phases" do
      expect(helper.moon_phase_numeric(0.01)).to eq("1")
      expect(helper.moon_phase_numeric(0.26)).to eq("1")
      expect(helper.moon_phase_numeric(0.51)).to eq("1")
      expect(helper.moon_phase_numeric(0.76)).to eq("1")

      expect(helper.moon_phase_numeric(0.07)).to eq("2")
      expect(helper.moon_phase_numeric(0.1)).to eq("3")
      expect(helper.moon_phase_numeric(0.14)).to eq("4")
      expect(helper.moon_phase_numeric(0.2)).to eq("5")
      expect(helper.moon_phase_numeric(0.24)).to eq("6")
    end
  end

  context('#moon_phase_icon_class') do
    it "should compute corect icons for all moon phases" do
      title, css_classes = helper.moon_phase_icon_class(0)
      expect(css_classes).to eq("wi weather-icon wi-moon-new")

      title, css_classes = helper.moon_phase_icon_class(0.25)
      expect(css_classes).to eq("wi weather-icon wi-moon-first-quarter")

      title, css_classes = helper.moon_phase_icon_class(0.5)
      expect(css_classes).to eq("wi weather-icon wi-moon-full")

      title, css_classes = helper.moon_phase_icon_class(0.75)
      expect(css_classes).to eq("wi weather-icon wi-moon-last-quarter")

      title, css_classes = helper.moon_phase_icon_class(0.01)
      expect(css_classes).to eq("wi weather-icon wi-moon-waxing-crescent-1")

      title, css_classes = helper.moon_phase_icon_class(0.36)
      expect(css_classes).to eq("wi weather-icon wi-moon-waxing-gibbous-3")

      title, css_classes = helper.moon_phase_icon_class(0.69)
      expect(css_classes).to eq("wi weather-icon wi-moon-waning-gibbous-5")

      title, css_classes = helper.moon_phase_icon_class(0.80)
      expect(css_classes).to eq("wi weather-icon wi-moon-waning-crescent-1")

    end
  end
end
