ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'
require 'rspec/rails'
require 'database_cleaner'
require 'draper/test/rspec_integration'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join('../../spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Cargaremos el seed, despues evitaremos borrar esas tablas
  # TODO : Buscar una solucion estandar
  load "#{Rails.root}/db/seeds.rb"

  config.add_setting :seeded_tables
  config.seeded_tables = %w(paises provincias subtipos usuarios tematicas)

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation, except: config.seeded_tables
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    # having this inside an 'unless ...metadata' block may cause
    # timeouts and calling it always causes no problem
    DatabaseCleaner.clean
  end
end
