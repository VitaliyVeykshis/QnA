source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
# Templating
gem 'slim-rails'
# Chore
gem 'decent_exposure', '3.0.0'
gem 'interactor'
# Authentication
gem 'devise'
# Third party
gem "aws-sdk-s3", require: false
gem 'octokit', '~> 4.0'
# UI
gem 'bootstrap', '~> 4.3.1'
gem 'jquery-rails'
gem 'font-awesome-rails'
# Nested forms
gem 'cocoon'
# Data in JS
gem 'gon'
# Client side templating engine
gem 'skim'
# OAuth authentication
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-vkontakte'
# Authorization
gem 'pundit'
# OAuth 2 provider functionality
gem 'doorkeeper'
# JSON:API serializer for Ruby Objects
gem 'fast_jsonapi'
# Background processing
gem 'sidekiq'
# Sidekiq monitoring
gem 'sinatra', require: false
# Cron jobs
gem 'whenever', require: false
# Full-text search
gem 'mysql2'
gem 'thinking-sphinx'
# JS runtime
gem 'mini_racer'
# Web server
gem 'unicorn'
# Cache
gem 'redis-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Preview email
  gem 'letter_opener'
  # Deployment tools
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'capybara'
  gem 'webdrivers'
  gem 'launchy'
  gem 'action-cable-testing'
  gem 'test-prof'
  gem 'capybara-email'
  # Pundit matchers
  gem 'pundit-matchers', '~> 1.6.0'
  gem 'timecop'
  gem 'database_cleaner'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
