source 'http://rubygems.org'

gem 'rails', '3.2.11'

# Bundle authentication
gem 'devise'
gem 'devise_openid_authenticatable', :git => 'git://github.com/nbudin/devise_openid_authenticatable.git', :tag => 'v1.1.1'

# Bundle the extra gems:
gem 'will_paginate', :require => 'will_paginate'
gem 'nokogiri'
gem 'rack-offline'
gem 'chronic'   #parsing dates

gem 'jquery-rails'

#Gets rid of annoying UTF-8 string error in rack
gem "escape_utils"

gem 'libv8'
gem 'therubyracer'

# Deploy with Capistrano
gem 'capistrano'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development do
  gem "nifty-generators"
  gem 'rails-erd'
end

group :development, :test do
  gem 'sqlite3-ruby' #, :require => 'sqlite3'  
  gem 'autotest'  #use with 'bundle exec autotest'
  gem 'autotest-growl'
  gem 'autotest-rails-pure' #to use Test:Unit
end

group :maconly do #if not using mac, run "bundle install --without maconly"
  # gem 'autotest-fsevent'
end

group :development, :test do
  gem 'single_test'
  gem 'rspec-rails'
  #gem "metric_fu" #use with 'rake metrics:all'
end

group :test do
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem "database_cleaner"
  gem "cucumber-rails", :require => false
  gem 'single_test'
  gem 'spork'
  # gem 'launchy'
end


group :production do
  gem 'pg'
  gem 'thin'
end

group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>= 1.0.3'
end
