Dir.glob("spec/steps/**/*steps.rb") { |f| load f, true }

RSpec.configure do |config|
  # make sure all turnip steps are implemented
  config.raise_error_for_unimplemented_steps = true
end
