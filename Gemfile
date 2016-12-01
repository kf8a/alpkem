source 'https://rubygems.org'

gem 'rails', '~>4.2.7'

# Bundle authentication
gem 'devise'
gem 'devise-encryptable'

# Bundle the extra gems:
#gem 'will_paginate', :require => 'will_paginate'
gem 'chronic'   #parsing dates

gem 'workflow'

gem 'jquery-rails'
gem 'jquery-ui-rails'

#Gets rid of annoying UTF-8 string error in rack
gem "escape_utils"

gem 'dotenv-rails'
gem 'carrierwave'

# Deploy with Capistrano
gem 'capistrano', '2.15.5'

gem 'therubyracer'
#gem 'libv8'

# use syslog
gem "syslog-logger"

gem 'prometheus-client', '~> 0.6.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

gem 'kaminari'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
#gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'web-console', group: :development

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem "byebug"
  gem "spring"
  gem 'rspec-rails'
  # gem "metric_fu" #use with 'rake metrics:all'
end

group :test do
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  #gem 'capybara'
  gem "database_cleaner"
  # gem "cucumber-rails", :require => false
  gem "sqlite3"
end

gem 'pg'

group :production do
  gem 'unicorn'
end
