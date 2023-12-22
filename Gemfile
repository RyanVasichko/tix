source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0rc1"

gem "bcrypt", "~> 3.1.7"
gem "cssbundling-rails"
gem "jsbundling-rails"
gem "pagy"
gem "sqlite3", "~> 1.6"
gem "activerecord-enhancedsqlite3-adapter", "~> 0.4.0"
gem "puma", "~> 6.0"
gem "rails", "~> 7.1.2"
gem "redis"
gem "solid_cache"
gem "solid_queue"
gem "sprockets-rails"
gem "stimulus-rails"
gem "stripe"
gem "turbo-rails"

gem "appsignal"
gem "aws-sdk-s3", require: false
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "image_processing", "~> 1.2"

gem "factory_bot_rails"
gem "faker"

group :development, :test do
  gem "awesome_print"
  gem "byebug"
  gem "htmlbeautifier"
  gem "rubocop"
  gem "foreman"
end

group :development do
  gem "bullet"
  gem "rack-mini-profiler"
  gem "web-console"
  gem "pg", "~> 1.1" # POSTMIGRATION: Remove
  gem "paperclip" # POSTMIGRATION: Remove
end

group :test do
  gem "capybara"
  gem "launchy"
  gem "selenium-webdriver"
  gem "simplecov"
end
