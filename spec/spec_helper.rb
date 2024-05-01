# frozen_string_literal: true

require 'aws_local_config_parser'
require 'debug'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Support focusing on individual specs, but prevent focus for CI runs
  config.filter_run focus: true unless ENV['CI']
  config.run_all_when_everything_filtered = true

  if ENV['CI']
    config.before(:example, :focus) do
      raise 'This example was committed with `:focus` and should not have been'
    end
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
