require "bundler/setup"

require "simplecov"
SimpleCov.start do
  enable_coverage :branch
end

require "vcr"
require_relative "helpers/discogs_api"
require_relative "helpers/hash_except_path"
require_relative "../lib/discogs_data"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Helpers
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end
