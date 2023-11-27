source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails",  "~> 7.1.0"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 6.0"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
gem 'bcrypt', '~> 3.1.7'
gem "good_job"
gem "redis"
gem "solid_cache"
gem "stripe"
gem "pagy"

gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "ruby-vips"
gem 'aws-sdk-s3', require: false
gem 'appsignal'

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem "factory_bot_rails"
gem "faker"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "htmlbeautifier"
  gem "rubocop"
  gem 'awesome_print'
end

group :development do
  gem "web-console"
  gem "rack-mini-profiler"
  gem "bullet"
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  gem "solargraph"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "launchy"
end
