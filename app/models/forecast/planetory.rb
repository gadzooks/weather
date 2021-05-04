require_dependency 'initialize_from_hash'

module Forecast
class Planetory
  include ::InitializeFromHash

  MY_ATTRIBUTES = :sunriseEpoch, :sunsetEpoch, :moonPhases
  attr_accessor *MY_ATTRIBUTES

  def initialize(input)
    setup_instance_variables(input)
    @sunriseEpoch = Time.at(@sunriseEpoch) if @sunriseEpoch
    @sunsetEpoch = Time.at(@sunsetEpoch) if @sunsetEpoch
  end

end
end
