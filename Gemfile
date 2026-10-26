source "https://rubygems.org"

gemspec

# CI pins the Pay major under test via PAY_VERSION (e.g. "11" or "12") so we verify both lines
# the gemspec allows. Unset (local dev), Bundler just uses the gemspec's pay range.
if (pay_major = ENV["PAY_VERSION"].to_s).match?(/\A\d+\z/)
  gem "pay", "~> #{pay_major}.0"
end

# The Square SDK is an app-provided dependency (see the gemspec), so this gem does not declare it.
# Declare it here for the dummy app and test suite, exactly as a host app would in its own Gemfile.
gem "square.rb", "~> 47"

# Test/dev
gem "sqlite3"
gem "webmock"
gem "mocha"
gem "standard"
gem "puma"

# Asset/engine deps needed to boot the dummy Rails app
gem "importmap-rails"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
