require "bundler/setup"
require "rspec/json_expectations"
require "webmock/rspec"
require "simplecov"

require "support/api_stubs"

SimpleCov.at_exit do
  SimpleCov.result.format!
  SimpleCov.minimum_coverage 100
end
SimpleCov.start do
  add_filter "/spec/"
end

require "flowmailer_rails"

Time.zone = "UTC"

RSpec.configure do |config|
  include ApiStubs

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
