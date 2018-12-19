require 'rails_helper'

step "I go to the :particular page" do |particular|
  visit(test_path)
end

step "I should see the current weather forecasts" do
  page.has_content? 'FAKE results'
  page.has_css?('table.weather-forecast-summary')
  page.has_css?('table.weather-forecast')
end
