source 'http://rubygems.org'

gem 'rails', '3.0.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'devise'#, :git => 'git://github.com/plataformatec/devise.git', :branch => 'omniauth'
#gem 'omniauth'
gem 'devise_openid_authenticatable'

gem 'will_paginate', :require => 'will_paginate'
gem 'RedCloth'

#Gets rid of annoying UTF-8 string error in rack
gem "escape_utils"

gem "metric_fu"

# Deploy with Capistrano
gem 'capistrano'

# Bundle the extra gems:
gem 'nokogiri'

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
end

group :test do
  gem "shoulda"
  gem "factory_girl"
  gem 'capybara'
  gem "database_cleaner"
  gem "cucumber-rails"
  gem "cucumber"
  gem 'spork'
  gem 'launchy'
  gem "mocha"
  gem 'ruby-prof'

  if RUBY_VERSION > "1.9"
    gem 'simplecov'
    gem 'simplecov-html'
  end
end

group :production do
  gem 'pg'
end
