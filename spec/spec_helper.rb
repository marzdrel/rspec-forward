require "bundler/setup"
require "rspec/forward"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.verify_doubled_constant_names = true
  end

  config.around(:each, no_truncate: true) do |example|
    instance = RSpec::Support::ObjectFormatter.default_instance
    current = instance.max_formatted_output_length
    instance.max_formatted_output_length = nil

    example.run

    instance.max_formatted_output_length = current
  end
end
