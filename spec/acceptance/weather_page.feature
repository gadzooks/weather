Feature: Showing weather forecasts

  Scenario: check out the weather forecast
    When I go to the "weather" page
    Then I should see the current weather forecasts
