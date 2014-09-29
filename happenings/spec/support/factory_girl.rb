# RSpec
# spec/support/factory_girl.rb

require 'factory_girl'
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  factory_girl_results = {}
  config.before(:suite) do
    ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |name, start, finish, id, payload|
      factory_name = payload[:name]
      strategy_name = payload[:strategy]
      factory_girl_results[factory_name] ||= {}
      factory_girl_results[factory_name][strategy_name] ||= 0
      factory_girl_results[factory_name][strategy_name] += 1
    end
  end

  # spec/support/factory_girl.rb
  RSpec.configure do |config|
    # additional factory_girl configuration

    config.before(:suite) do
      begin
        DatabaseCleaner.start
        FactoryGirl.lint
      ensure
        DatabaseCleaner.clean
      end
    end
  end

  config.after(:suite) do
    puts factory_girl_results
  end
end


# Test::Unit
class Test::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end

# Cucumber
World(FactoryGirl::Syntax::Methods)

# Spinach
class Spinach::FeatureSteps
  include FactoryGirl::Syntax::Methods
end

# MiniTest
class MiniTest::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end

# MiniTest::Spec
class MiniTest::Spec
  include FactoryGirl::Syntax::Methods
end

# minitest-rails
class MiniTest::Rails::ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end