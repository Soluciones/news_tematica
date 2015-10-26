ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../test/dummy/config/environment', __FILE__)
require 'ffaker'
require 'factory_girl_rails'

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
