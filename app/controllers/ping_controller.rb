class PingController < ActionController::Base
  skip_before_action :track_ahoy_visit
  def deep_ping
    head :ok
  end

  def about
    hsh = {
      'rails-version' => '7.0.1',
      'ruby-version' => '3.0.3'
    }

    render json: hsh.to_json
  end
end
