source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

# Infrastructure
gem "rails", "8.0.1"
gem "puma", "~> 6.0"
gem "redis"
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "mission_control-jobs"
gem "msgpack", ">= 1.7.0"

# Assets
gem "propshaft"
gem "importmap-rails", "~> 2.0"
gem "requestjs-rails"
gem "stimulus-rails"
gem "turbo-rails", "~> 2.0"
gem "tailwindcss-rails", "~> 3.0"
gem "stripe"

# Database
gem "sqlite3", "~> 2.2"

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Storage
gem "aws-sdk-s3", require: false
gem "image_processing", "~> 1.2"

gem "hotwire_combobox"
gem "bcrypt", "~> 3.1.7"
gem "pagy"

gem "progress_bar", "~> 1.3"

# Fake data generation
gem "faker"
gem "factory_bot_rails"
gem "mocha"

group :development, :test do
  gem "rubocop-rails-omakase", require: false
  gem "awesome_print"
  gem "debug"
  gem "rubocop"
  gem "foreman"
  gem "brakeman", require: false
end

group :development do
  gem "rack-mini-profiler"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"

  gem "simplecov"
  gem "webmock"
end

gem "thruster"
