source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

# Infrastructure
gem "rails", "~> 7.0"
gem "puma", "~> 6.0"
gem "redis"
gem "solid_cache"
gem "solid_queue"
gem "appsignal"
gem "mission_control-jobs"

# Assets
gem "propshaft"
gem "importmap-rails", "~> 2.0"
gem "requestjs-rails"
gem "stimulus-rails"
gem "turbo-rails", "~> 2.0"
gem "tailwindcss-rails", "~> 2.3"
gem "stripe"

# Database
gem "pg"

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "chronic"

# Storage
gem "aws-sdk-s3", require: false
gem "image_processing", "~> 1.2"

gem "hotwire_combobox"
gem "bcrypt", "~> 3.1.7"
gem "pagy"

gem "faker"
gem "factory_bot_rails"

group :development, :test do
  gem "bullet", "~> 7.1"
  gem "rubocop-rails-omakase", require: false
  gem "awesome_print"
  gem "byebug"
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
  gem "mocha"
  gem "simplecov"
  gem "webmock"
end
