require "rspec"
require "rspec/mocks"
require "rspec/forward/version"
require "rspec/forward/forward_methods"
require "rspec/forward/forward_to_instance"
require "rspec/forward/forward_to_instance_build"

module RSpec
  module Forward
    class Error < StandardError; end

    def forward_to_instance(expected)
      ForwardToInstance.new(expected)
    end

    def forward_to_instance_build(expected)
      ForwardToInstanceBuild.new(expected)
    end
  end
end

::RSpec.configure do |config|
  config.include ::RSpec::Forward
end
