source "http://rubygems.org"

# Declare your gem's dependencies in news_tematica.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'haml-rails'
gem 'premailer-rails'

# Para archivos estáticos
gem 'paperclip', '2.3.11'
gem 'aws-s3', :require => 'aws/s3'

# jquery-rails is used by the dummy application
gem "jquery-rails"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'

gem 'draper'

group :test do
  gem 'rspec-html-matchers'
  gem 'rspec-instafail'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'timecop'
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'capybara'
  gem 'simplecov', require: false
  gem 'launchy'
end

group :development, :test do
  gem 'mailcatcher' # Set your app to deliver to smtp://127.0.0.1:1025 instead of your default SMTP server, then check out http://127.0.0.1:1080 to see the mail.
  gem 'debugger'
  gem 'rspec-rails' # Neceario para crear los specs automáticamente con los comandos 'rails generate'
end
