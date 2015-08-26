RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerHelpers, :type => :controller
end