source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "bcrypt", "~> 3.1.7"
gem "cssbundling-rails"
gem "good_job"
gem "jsbundling-rails"
gem "pagy"
gem "pg", "~> 1.1"
gem "puma", "~> 6.0"
gem "rails", "~> 7.1.2"
gem "redis"
gem "solid_cache"
gem "sprockets-rails"
gem "stimulus-rails"
gem "stripe"
gem "turbo-rails"

gem "appsignal"
gem "aws-sdk-s3", require: false
gem "bootsnap", require: false
gem "ruby-vips"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem "factory_bot_rails"
gem "faker"

group :development, :test do
  gem "awesome_print"
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "htmlbeautifier"
  gem "byebug"
  gem "rubocop"
end

group :development do
  gem "bullet"
  gem "rack-mini-profiler"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "launchy"
  gem "selenium-webdriver"
  gem "simplecov"
end
