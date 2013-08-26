source 'http://rubygems.org'

gem 'rails', '3.2.14'

# Bundle authentication
gem 'devise'

# Bundle the extra gems:
gem 'will_paginate', :require => 'will_paginate'
gem 'nokogiri'
gem 'rack-offline'
gem 'chronic'   #parsing dates

gem 'jquery-rails'

#Gets rid of annoying UTF-8 string error in rack
gem "escape_utils"


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
end

group :development, :test do
  gem 'single_test'
  gem 'rspec'
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
  gem 'unicorn'
end

group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer'
end
