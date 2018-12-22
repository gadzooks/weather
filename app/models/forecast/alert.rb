require_dependency 'lib/initialize_from_hash'
module Forecast
HEREDOC =<<-SAMPLE_ALERT
  "alerts": [
    {
      "title": "Coastal Flood Advisory",
      "regions": [
        "Admiralty Inlet Area",
        "Bremerton and Vicinity",
        "Everett and Vicinity",
        "Hood Canal Area",
        "San Juan County",
        "Seattle and Vicinity",
        "Southwest Interior",
        "Tacoma Area",
        "Western Skagit County",
        "Western Whatcom County"
      ],
      "severity": "advisory",
      "time": 1545559200,
      "expires": 1545588000,
      "description": "...COASTAL FLOOD ADVISORY REMAINS IN EFFECT FROM 2 AM TO 10 AM PST SUNDAY... * COASTAL FLOODING...Minor tidal overflow will produce some minor flooding of low lying areas along the shoreline for a couple of hours around high tide. * SOME AFFECTED LOCATIONS...Shorelines around Admiralty Inlet, the Northern Inland Waters, and the Puget Sound including Bellingham, Port Townsend, Oak Harbor, Friday Harbor, Everett, Seattle, Tacoma and Olympia. * TIMING...High tide will occur early Sunday morning. * TIDE INFO...High tides will generally occur during the early morning hours between 5 and 7 AM Sunday. These conditions may return Monday. * IMPACTS...Minor tidal overflow means that water levels will rise to up to a foot above what starts producing flooding along shore lines. Parks and roadways along the shoreline are most likely to be affected. The threat of beach erosion will be increased.\n",
      "uri": "https://alerts.weather.gov/cap/wwacapget.php?x=WA125ACE93FACC.CoastalFloodAdvisory.125ACEA386E0WA.SEWCFWSEW.97a4763f2bf535d85e44b51d233d98ec"
    }
  ],
SAMPLE_ALERT
class Alert
  include ::InitializeFromHash

  MY_ATTRIBUTES = :title, :regions, :severity, :time, :expires, :description, :uri

  def initialize(input)
    self.setup_instance_variables(input)
  end

end
end
