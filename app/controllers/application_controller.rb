class ApplicationController < ActionController::Base
  after_action :track_action, unless: -> { params[:controller] == 'ping' }
  before_action :authenticate_user!, unless: -> { params[:controller] == 'ping' }


  #########
  protected
  #########

  def track_action
    ahoy.track "Ran action", request.path_parameters
  end
end
