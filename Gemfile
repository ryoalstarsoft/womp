source 'https://rubygems.org'
ruby '2.5.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.0'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Load App faster
gem 'bootsnap', require: false

# Browser Detection
gem 'browser'

gem 'flex-slider-rails'

# Jquery UI
gem 'jquery-ui-rails'

gem 'jquery-rails'

gem "jquery-slick-rails"

# WYSIWYG
gem 'trix'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Payment Processing
gem 'stripe'

# Ability to count business days
gem 'business_time'

# Search / Filters
gem 'ransack'

# Spreadsheets
gem 'roo'
gem 'roo-xls'

# Background Jobs
gem 'resque'
gem 'resque-web', require: 'resque_web'

# User Authentication
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook', '~> 4.0.0'
gem 'omniauth-google-oauth2'

# POST Requests to Sketchfab API
gem 'multipart-post'

# Exception Notifications
gem 'exception_notification'
gem 'slack-notifier'

# HTTP Requests
gem 'httparty'
gem 'httmultiparty'

# Uploads
gem "aws-sdk-s3", require: false
gem 'mini_magick'

# Javascript Configuration
gem 'webpacker'
gem 'react-rails'

# PDF Page Count Validation
gem 'pdf-reader'

# Breadcrumbs
gem "gretel"

gem 'font-awesome-sass'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

	# Development ENV Variables
	gem 'figaro'

  # Performance Tracking
  gem 'rack-mini-profiler' # Per Page Speed Checks
  gem 'flamegraph' # Per Page Speed Checks
  gem 'stackprof' # Per Page Speed Checks
  gem 'bullet' # N+1 Query Checks
  gem "rails_best_practices" # Scan Codebase For Best Practices

	# Debugging
	gem 'pry'

	# Better error pages
	gem "better_errors"
	gem "binding_of_caller"

	# Email in development
	gem "letter_opener"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :production do
  # Performance Tracking
  gem "skylight"

  # Heroku in Production
  gem 'rails_12factor'
end
