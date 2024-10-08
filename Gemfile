# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
gem 'rake','~> 12.3.1'
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

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'faker'
end

group :development do
  # gem 'tracer_bullets', github: 'Capitalytics/tracer_bullets'
  gem 'better_errors'
  gem 'foreman'
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# React
gem 'webpacker'
gem 'webpacker-react'

# Dev Tools
gem 'autoprefixer-rails' # vendor prefixes
gem 'jquery-rails' # jQuery

# Misc
gem 'aws-sdk-s3' # AWS S3
gem 'friendly_id' # URL Slugs
gem 'local_time' # time formatting
gem 'search_cop' # search

# APIs
gem 'httparty' # HTTP requests
gem 'rack-cors' # CORS

# Validation
gem 'validates_email_format_of' # email validation
gem 'file_validators' # file validation

# Rendering
gem 'barby' # barcodes
gem 'cairo' # SVG/PNG rendering
gem 'mini_magick' # image manipulation
gem 'nokogiri' # inline SVG
gem 'prawn' # PDFs
gem 'combine_pdf' # more PDFs

# Auth
gem 'devise' # authentication
gem 'devise_invitable' # inviting users
gem 'pundit' # authorization/permissions

# Admin
gem 'pretender' # login as other users

# Displaying Data
gem 'chartkick' # charting data
gem 'groupdate' # grouping data

# Optimization
gem 'skylight' # performance
gem 'redis' # caching
