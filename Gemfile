source 'https://rubygems.org'

# Declare your gem's dependencies in news_tematica.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'pg'

# Para archivos estáticos
gem 'paperclip'
gem 'aws-sdk', '< 2.0'
gem 'aws-s3', require: 'aws/s3'
gem 'suscribir', git: 'https://github.com/Soluciones/suscribir.git', branch: 'upgrade-rails'
gem 'psique', '= 0.1.0'
gem 'mandrill-api', require: 'mandrill'

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'

group :develoment, :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'capybara'
  gem 'rspec-rails', '~> 3.0'
  gem 'pry'
  gem 'binding_of_caller'
end
