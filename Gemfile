# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '~>8.0'
#gem 'sassc-rails'

# Bundle authentication
gem 'devise'
gem 'devise-encryptable'

# block upgrade until we move to rails 7
gem 'concurrent-ruby'

gem 'ostruct'
gem 'bigdecimal'
gem 'mutex_m'
gem 'syslog'

gem 'pg'

gem 'csv'

# Bundle the extra gems:
# gem 'will_paginate', :require => 'will_paginate'
gem 'chronic' # parsing dates

gem 'workflow-activerecord',  '~> 6.0'

# gem 'jquery-rails'

# Gets rid of annoying UTF-8 string error in rack
gem 'escape_utils'

gem 'carrierwave'
gem 'dotenv-rails'

# use syslog
gem 'syslog-logger'

gem 'kaminari'

gem 'turbo-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

gem 'importmap-rails'


# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'sqlite3'
end

group :development do
  gem 'bcrypt_pbkdf'
  gem 'capistrano'
  gem 'capistrano-asdf'
  gem "tidewave"
  gem 'rubocop'
  # gem 'capistrano3-unicorn'
  gem 'capistrano3-puma' #,  github: "seuros/capistrano-puma"
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'ed25519'
  gem 'rbnacl'
  gem 'rbnacl-libsodium'
  gem "webrick"
  gem 'web-console'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
end

group :production do
  gem 'puma'
end

gem "propshaft", "~> 1.2"

gem "tailwindcss-rails", "~> 3.3.1"
gem "tailwindcss-ruby", "~> 3.4"
