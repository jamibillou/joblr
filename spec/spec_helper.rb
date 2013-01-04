require 'spork'

Spork.prefork do
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  # Requires supporting ruby files in spec/support/
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  # Decrease Devise password strength
  module Devise
    module Models
      module DatabaseAuthenticatable
        protected

        def password_digest(password)
          password
        end
      end
    end
  end

  # Lower cost of BCrypt encryption
  BCrypt::Engine::DEFAULT_COST = 1

  # Increase log level
  Rails.logger.level = 4

  RSpec.configure do |config|
    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures.
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # Set to false if you're not using ActiveRecord, or if you'd prefer not to run
    # each of your examples within a transaction.
    config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies.
    config.order = 'random'

    # Lower garbage collection frequency
    config.before(:all) do
      DeferredGarbageCollection.start
    end

    config.after(:all) do
      DeferredGarbageCollection.reconsider
    end
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
end
