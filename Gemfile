# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '~>6.0'
gem 'sassc-rails'

# Bundle authentication
gem 'devise'
gem 'devise-encryptable'

gem 'pg'

# Bundle the extra gems:
# gem 'will_paginate', :require => 'will_paginate'
gem 'chronic' # parsing dates

gem 'workflow-activerecord', '>= 4.1', '< 6.0'

gem 'jquery-rails'
gem 'jquery-ui-rails'

# Gets rid of annoying UTF-8 string error in rack
gem 'escape_utils'

gem 'carrierwave'
gem 'dotenv-rails'

gem 'therubyracer'

# use syslog
gem 'syslog-logger'

gem 'prometheus-client', '~> 0.6.0'

# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

gem 'kaminari'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

gem 'webpacker'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'byebug'
  # gem 'rspec-rails'
  gem 'rspec-rails', git: 'https://github.com/rspec/rspec-rails', tag: 'v4.0.0.beta4'
  gem 'spring'
  gem 'sqlite3'
end

group :development do
  gem 'bcrypt_pbkdf'
  gem 'capistrano', '~> 3.11', require: false
  gem 'capistrano3-unicorn'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'ed25519'
  gem 'rbnacl', '< 5.0'
  gem 'rbnacl-libsodium'
  gem 'web-console'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
end

group :production do
  gem 'unicorn'
end
