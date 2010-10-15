source 'http://rubygems.org'

gem 'rails', '3.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'ruby-openid', :require => 'openid'
gem 'authlogic', :git => 'git://github.com/odorcicd/authlogic.git', :branch => 'rails3'
gem 'authlogic-oid', :require => 'authlogic_openid'
gem 'will_paginate', :require => 'will_paginate'
gem 'RedCloth'
gem 'rack-openid'

#Gets rid of annoying UTF-8 string error in rack
gem "escape_utils"

gem "metric_fu"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
gem 'nokogiri'
gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem "shoulda"
  gem "factory_girl"
  gem 'capybara'
  gem "database_cleaner"
  gem "cucumber-rails"
  gem "cucumber"
  gem 'spork'
  gem 'launchy'


  if RUBY_VERSION > "1.9"
    gem 'simplecov'
    gem 'simplecov-html'
  end
end