ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../test/dummy/config/environment', __FILE__)
require 'rspec/rails'
# require 'rspec/autorun'
require 'ffaker'
require 'factory_girl_rails'
require 'database_cleaner'
require 'draper/test/rspec_integration'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  # Cada vez que se arranque cargaremos el seed, después evitaremos borrar esas tablas
  # TODO : Buscar una solución estándar
  load "#{Rails.root}/db/seeds.rb"

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    # DatabaseCleaner.clean_with :truncation, except: %w[paises provincias subtipos tipo_productos constantes likerts pagestaticas usuarios permisos tematicas]
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
