source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# profiling
gem 'activemerchant'
gem 'activerecord-import', '~> 0.21.0'
gem 'barby'
gem 'bootsnap', '~> 1.1', '>= 1.1.3'
gem 'bootstrap', '~> 4.0.0.beta2'
gem 'carrierwave'
gem 'cloudinary'
gem 'devise'
gem 'exception_handler'
gem 'geocoder'
gem 'high_voltage', '~> 3.0.0'
gem 'httparty'
gem 'jquery-rails'
gem 'kaminari'
gem 'mini_magick'
gem 'piet'
gem 'popper_js', '~> 1.12.1'
gem 'rack-mini-profiler'
gem 'roo', '~> 2.7', '>= 2.7.1'
gem 'sidekiq'
gem 'stripe'
gem 'trix'
gem 'uploadcare-rails', '~> 1.1'
gem 'virtus'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'fuubar'
  gem 'rspec-rails'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'capybara'
  gem 'chromedriver-helper'
  gem 'poltergeist'
  gem 'rails-controller-testing'
  gem 'rspec-instafail'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'better_errors'
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'pry-rails'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
