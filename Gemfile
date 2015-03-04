source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use sqlite3 as the database for Active Record on hamish's chromebook # Pulled out as going to use pg instead.
group :chromebookdev, :chromebooktest do
#  gem 'sqlite3'
end

#group :development, :test, :production do
  gem 'pg'
#end

group :development, :test do
  gem 'rspec-rails', '2.13.1'
  gem 'annotate', ">=2.6.0"
  gem 'meta_request'
  gem "better_errors"
end

group :production do
  gem 'rails_12factor', '0.0.2'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  gem 'factory_girl_rails', '4.2.1'
end
  
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '2.1.1'
gem 'bootstrap-sass', '~> 3.1.1'
gem 'sprockets', '2.11.0'
gem 'faker', '1.1.2'
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.9'
gem 'carrierwave'
gem 'mini_magick'   # changed from rmagick
#gem 'rmagick'   # changed as causing issues installing gems
gem 'select2-rails'
gem 'paper_trail'
gem 'font-awesome-rails'
gem 'roo'
#gem 'jquery-datatables-rails', '~> 2.1.10.0.3'
#gem 'jquery-datatables-rails', '~> 3.1.1'
gem 'xeroizer', '~> 2.15.6'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'pxpay'
gem 'money'
gem 'google_currency'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
group :chromebookdev, :chromebooktest do
  gem 'therubyracer', platforms: :ruby   # uncommented for  chromebook dev
end

# Use jquery as the JavaScript library
gem 'jquery-rails'

# datepicker gems
#gem 'momentjs-rails', '~> 2.8.1' #OLD removed due to conflict with tablesorter
#gem 'bootstrap3-datetimepicker-rails', '~> 3.1.2' #OLD removed due to conflict with tablesorter
gem 'bootstrap-datepicker-rails'

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
gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
