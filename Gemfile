source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.2'
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails', '~> 3.5'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 6.4'
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails', '~> 2.0'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails', '~> 2.0'
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails', '~> 1.3'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder', '~> 2.13'
# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'active_storage_validations', '~> 1.1'
gem 'apollo_upload_server', '~> 2.1'
gem 'aws-sdk-s3', '~> 1.167'
gem 'bootsnap', '~> 1.18', require: false
gem 'cancancan', '~> 3.6'
gem 'devise', '~> 4.9'
gem 'devise-jwt', '~> 0.12'
gem 'graphql', '~> 2.3'
gem 'graphql_playground-rails', '~> 2.1'
gem 'rolify', '~> 6.0'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'annotate', '~> 3.2'
  gem 'brakeman', '~> 6.2', require: false
  gem 'bullet', '~> 7.2'
  gem 'debug', '~> 1.9', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'dotenv-rails', '~> 2.8'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'fasterer', '~> 0.11', require: false
  gem 'overcommit', '~> 0.64', require: false
  gem 'rubocop', '~> 1.66', require: false
  gem 'rubocop-performance', '~> 1.22'
  gem 'rubocop-rails', '~> 2.26'
  gem 'rubocop-rspec', '~> 3.0'
  gem 'web-console', '~> 4.2'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara', '~> 3.40'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.4'
  gem 'rspec-rails', '~> 6.1'
  gem 'selenium-webdriver', '~> 4.25'
  gem 'shoulda-matchers', '~> 6.4'
  gem 'simplecov', '~> 0.22', require: false
end
