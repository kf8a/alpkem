source 'http://rubygems.org'

gem 'rails', '3.0.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Bundle authentication
gem 'devise'
#gem 'omniauth'
gem 'devise_openid_authenticatable'

# Bundle the extra gems:
gem 'will_paginate', :require => 'will_paginate'
gem 'RedCloth'
gem 'nokogiri'
gem 'rack-offline'

#Gets rid of annoying UTF-8 string error in rack
gem "escape_utils"


# Deploy with Capistrano
gem 'capistrano'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development do
  gem "nifty-generators"
  gem 'mongrel', '1.2.0.pre2'
  gem 'rails-erd'
end

group :development, :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'  
  gem 'autotest'  #use with 'bundle exec autotest'
  gem 'autotest-rails-pure' #to use Test:Unit
end

group :test do
  gem "shoulda"
  gem "factory_girl"
  gem 'factory_girl_rails'
  gem 'capybara'
  gem "database_cleaner"
  gem "cucumber-rails"
  gem "cucumber"
  gem 'spork'
  gem 'launchy'
  gem "mocha"
  gem 'ruby-prof'
  #gem "metric_fu" #use with 'rake metrics:all'
  
end

group :production do
  gem 'pg'
end
