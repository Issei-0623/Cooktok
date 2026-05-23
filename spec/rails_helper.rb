require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |file| require file }
ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include SystemLoginHelper, type: :system
  config.use_transactional_fixtures = false
  config.filter_rails_from_backtrace!

  config.before(:each) do
    TestDatabaseCleaner.clean
  end

  config.before(:each, type: :system) do
    Capybara.reset_sessions!
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  end

  config.after(:each, type: :system) do
    Capybara.reset_sessions!
  end
end
