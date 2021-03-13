require "rspec/forward/version"
require "rspec/forward/forward_to_instance"

module RSpec
  module Forward
    class Error < StandardError; end
  end
end

::RSpec.configure do |config|
  config.include ::RSpec::Mocks::ExampleMethods
  config.include ::RSpec::Forward
end
