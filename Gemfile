source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
gem 'pg'

group :development, :test do
  gem 'rspec-rails', '2.13.1'
  gem 'annotate', ">=2.6.0"
  gem 'meta_request'
  gem "better_errors"
  gem 'web-console', '~> 2.0'
  gem 'wkhtmltopdf-binary-edge', '~> 0.12.2.1'
#gem "therubyracer" #only need this for local dev enviroments if no js installed
  gem 'byebug'
end

group :production do
  gem 'rails_12factor', '0.0.2'
end

group :staging, :production do
  gem 'wkhtmltopdf-heroku'
end

group :test do
# old way, decided to use minitest
#  gem 'selenium-webdriver', '2.35.1'
#  gem 'capybara', '2.1.0'
#  gem 'factory_girl_rails', '4.2.1'
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end
  
# Use SCSS for stylesheets
gem 'sass'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '2.1.1'
gem 'sprockets', '2.11.0'
gem 'faker', '1.4.2'
#gem 'will_paginate', '3.0.5'
gem 'kaminari'
gem 'materialize-sass', '0.96.1'
gem 'carrierwave'
gem "fog"
gem 'mini_magick'   # changed from rmagick
#gem 'rmagick'   # changed as causing issues installing gems
#gem 'select2-rails' #installed directly in vendor folder as wanted lastest version.
gem 'paper_trail', '~> 4.0.0.beta'
gem 'font-awesome-rails'
gem 'roo'
gem 'jquery-datatables-rails'
gem 'ajax-datatables-rails'
gem 'xeroizer', '~> 2.15.6'
gem 'wicked_pdf'
#gem 'wkhtmltopdf-binary', # removed as having issues accessing https resourses from older gem - replaced above with another similiar one.

gem 'pxpay'
gem 'money'
gem 'google_currency'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
gem 'toastr-rails'    # pretty toast notification
gem 'nprogress-rails' # pretty progress bar at top of screen when using ajax and turbolinks
gem 'responders', '~> 2.0'
gem 'delayed_job_active_record'
gem 'cocoon'
gem 'dropbox-sdk'
gem 'net-ssh'

gem 'ckeditor' # rich text editor

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'

# Use debugger
# gem 'debugger', group: [:development, :test]


gem 'deep_cloneable', '~> 2.1.1'
