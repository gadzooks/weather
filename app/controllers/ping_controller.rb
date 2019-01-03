class PingController < ActionController::Base
  skip_before_action :track_ahoy_visit
  def deep_ping
    head :ok
  end
end
