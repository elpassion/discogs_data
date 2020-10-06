source "https://rubygems.org"

# Specify your gem's dependencies in discogs_data.gemspec
gemspec

gem "rake", "~> 12.0"

group :test do
  gem "rspec", "~> 3.0"
  gem "simplecov"
  gem "vcr"
  gem "webmock"
end

group :development, :test do
  gem "rubocop", require: false
  gem "rubocop-rspec", require: false
end
