class PingController < ActionController::Base
  def deep_ping
    head :ok
  end
end
