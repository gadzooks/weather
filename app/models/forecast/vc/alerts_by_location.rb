module Forecast
module Vc
class AlertsByLocation

  attr_reader :all_alerts

  def initialize
    @alerts_hash = {}
    @all_alerts = Set.new
    @next_alert_id = 'A'
  end

  def parse(vc_alerts_response)
    alerts_for_location = {}
    max_alert_epoch = Time.at(2000)
    (vc_alerts_response || []).each do |alert_hash|
      alert = Forecast::Vc::Alert.new(alert_hash)

      # Rails.logger.info alert_hash.inspect
      Rails.logger.debug alert.title

      if alert.expires
        max_alert_epoch = [max_alert_epoch, alert.expires].max
      end

      if @all_alerts.include?(alert)
        alert.alert_id = @all_alerts.find { |a| a.title == alert.title }.alert_id
        Rails.logger.debug "title already found : " + alert.title
        Rails.logger.debug "title already found : " + alert.alert_id
        alerts_for_location[alert.alert_id] = alert
      else
        Rails.logger.debug "title NOT found : " + alert.title
        alert.alert_id = @next_alert_id
        Rails.logger.debug "title NOT found : " + alert.alert_id
        alerts_for_location[@next_alert_id] = alert
        @all_alerts << alert
        @next_alert_id = @next_alert_id.next
      end
    end

    [alerts_for_location, max_alert_epoch]
  end


end
end
end
