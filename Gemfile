source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

# Infrastructure
gem "rails", github: "rails/rails", branch: "main"
gem "puma", "~> 6.0"
gem "redis"
gem "solid_cache"
gem "solid_queue"
gem "appsignal"

# Assets
gem "propshaft"
gem "importmap-rails", "~> 2.0"
gem "requestjs-rails"
gem "stimulus-rails"
gem "turbo-rails", "~> 2.0"
gem "tailwindcss-rails", "~> 2.3"
gem "stripe"

# Database
gem "sqlite3", "~> 1.7"

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Storage
gem "aws-sdk-s3", require: false
gem "image_processing", "~> 1.2"

gem "bcrypt", "~> 3.1.7"
gem "pagy"

group :development, :test do
  gem "rubocop-rails-omakase", require: false
  gem "awesome_print"
  gem "byebug"
  gem "rubocop"
  gem "foreman"
  gem "brakeman", require: false

  gem "faker"
  gem "factory_bot_rails"
end

group :development do
  gem "rack-mini-profiler"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "simplecov"
end
