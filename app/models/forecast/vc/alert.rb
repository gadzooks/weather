require_dependency 'initialize_from_hash'
HEREDOC =<<-SAMPLE_ALERT
  "alerts": [
    {
      "event": "Heat Advisory",
      "headline": "Heat Advisory issued June 03 at 4:46AM PDT until June 03 at 8:00PM PDT by NWS Spokane",
      "description": "...HEAT ADVISORY REMAINS IN EFFECT UNTIL 8 PM PDT THIS EVENING...\n* WHAT...High temperatures generally in the 90s.\n* WHERE...Peck, Clarkston, Pomeroy, Brewster, Omak, Gifford,\nCashmere, Lapwai, Nespelem, Oroville, Okanogan, Culdesac, Chelan,\nLewiston, Bridgeport, Entiat, and Wenatchee.\n* WHEN...Until 8 PM PDT this evening.\n* IMPACTS...Unusual early season heat may cause heat illnesses to\noccur.",
      "ends": "2021-06-03T20:00:00",
      "endsEpoch": 1622775600,
      "id": "NOAA-NWS-ALERTS-WA1261A5D1C068.HeatAdvisory.1261A5DFB830WA.OTXNPWOTX.feb785796e9d67112115273ac8082684",
      "language": "en",
      "link": "https://alerts.weather.gov/cap/wwacapget.php?x=NOAA-NWS-ALERTS-WA1261A5D1C068.HeatAdvisory.1261A5DFB830WA.OTXNPWOTX.feb785796e9d67112115273ac8082684"
    }
  ],
SAMPLE_ALERT

module Forecast
module Vc
class Alert
  include ::InitializeFromHash

  MY_ATTRIBUTES = :title, :regions, :time, :expires, :description, :uri, :alert_id, :link, :alert_details
  attr_accessor *MY_ATTRIBUTES

  SEVERITIES = { 'advisory' => 2, 'watch' => 1, 'warning' => 0 }

  def is_vc?
    true
  end

  def alert_details
    @alert_details
  end

  def severity
    'warning'
  end

  def numeric_severity
    SEVERITIES[severity] || 0
  end

  def initialize(input)
    compatible_hsh = make_compatible_for_alert(input)
    setup_instance_variables(input)
    @time = Time.at(@time) if @time
    @expires = Time.at(@expires) if @expires
    @severity = 'warning'
  end

  def ==(other)
    other.class == self.class && other.title == self.title
  end
  alias eql? ==

  def <=>(other)
    numeric_severity <=> other.numeric_severity
  end

  def hash
    title.hash
  end

  #######
  private
  #######
  # MY_ATTRIBUTES = :title, :regions, :severity, :time, :expires, :description, :uri, :alert_id
  def make_compatible_for_alert(hsh)
    return {} if hsh.blank?
    hsh['title'] = hsh.delete('event')
    hsh['expires'] = hsh.delete('endsEpoch')
    hsh['uri'] = hsh.delete('link')
    hsh['alert_details'] = hsh['description'] || ''

    hsh
  end

  # "description": "...HEAT ADVISORY REMAINS IN EFFECT UNTIL 8 PM PDT THIS EVENING...\n*
  # WHAT...High temperatures generally in the 90s.\n*
  # WHERE...Peck, Clarkston, Pomeroy, Brewster, Omak, Gifford,\nCashmere, Lapwai, Nespelem, Oroville, Okanogan, Culdesac, Chelan,\nLewiston, Bridgeport, Entiat, and Wenatchee.\n*
  # WHEN...Until 8 PM PDT this evening.\n*
  # IMPACTS...Unusual early season heat may cause heat illnesses to\noccur.",

  WHAT_MATCHER = /^*WHAT\.+([a-zA-Z\S\s]*)(WHERE)/
  WHERE_MATCHER = /^*WHERE\.+([a-zA-Z\S\s]*)(WHEN)/
  WHEN_MATCHER = /^*WHEN\.+([a-zA-Z\S\s]*)(IMPACTS)/
  IMPACTS_MATCHER = /^*IMPACTS\.+([a-zA-Z\S\s]*)$/

  AlertDetails = Struct.new(:link, :what, :where, :time, :impacts, :is_available) do
    def where?
      is_available && !where.blank?
    end

    def what?
      is_available && !what.blank?
    end

    def time?
      is_available && !time.blank?
    end

    def impacts?
      is_available && !impacts.blank?
    end
  end

  def alert_details=(line)
    @alert_details = AlertDetails.new

    unless line.blank?

      line = line.gsub('\n', ' ')
      line = line.gsub('*', '')

      what = line.match(WHAT_MATCHER)
      if what
        str = what[1] || ''
        @alert_details.what = str.strip.humanize
        @alert_details.is_available = true
      end

      where_line = line.match(WHERE_MATCHER)
      if where_line
        str = where_line[1] || ''
        @alert_details.where = str.strip.humanize
        @alert_details.is_available = true
      end

      time_line = line.match(WHEN_MATCHER)
      if time_line
        str = time_line[1] || ''
        @alert_details.time = str.strip.humanize
        @alert_details.is_available = true
      end

      impacts = line.match(IMPACTS_MATCHER)
      if impacts
        str = impacts[1]
        @alert_details.impacts = str.strip.humanize
        @alert_details.is_available = true
      end
    end

    @alert_details
  end

end
end
end
