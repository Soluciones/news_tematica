RSpec.configure do |config|
  # Avoid the need to explicit call FactoryGirl for building/creating factories
  config.include FactoryGirl::Syntax::Methods

  # Avoid errors of Factories with associations when using Rails preloaders
  config.before(:suite) { FactoryGirl.reload }
end
