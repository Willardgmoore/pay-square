ENV["RAILS_ENV"] = "test"

ENV["SQUARE_ENVIRONMENT"] ||= "sandbox"
ENV["SQUARE_SIGNING_SECRET"] ||= "test_square_signing_secret"
ENV["SQUARE_WEBHOOK_NOTIFICATION_URL"] ||= "https://example.com/pay/webhooks/square"

require File.expand_path("dummy/config/environment.rb", __dir__)
require "pay"
require "square"
require "pay/square"

ActiveRecord::Migrator.migrations_paths = [
  File.expand_path("dummy/db/migrate", __dir__),
  File.expand_path("../db/migrate", __dir__)
]
require "rails/test_help"
require "mocha/minitest"
require "webmock/minitest"

require_relative "support/square"

if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
  ActiveSupport::TestCase.fixture_paths << File.expand_path("fixtures", __dir__)
elsif ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
end
ActiveSupport::TestCase.fixtures :all

class ActiveSupport::TestCase
  include ActiveJob::TestHelper
end
