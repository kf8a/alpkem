source 'https://rubygems.org'

gem 'rails', '~>5.0'

# Bundle authentication
gem 'devise'
gem 'devise-encryptable'

gem 'pg'

# Bundle the extra gems:
# gem 'will_paginate', :require => 'will_paginate'
gem 'chronic' # parsing dates

gem 'workflow'

gem 'jquery-rails'
gem 'jquery-ui-rails'

# Gets rid of annoying UTF-8 string error in rack
gem 'escape_utils'

gem 'carrierwave'
gem 'dotenv-rails'

# Deploy with Capistrano
gem 'capistrano', '2.15.5'

gem 'therubyracer'

# use syslog
gem 'syslog-logger'

gem 'prometheus-client', '~> 0.6.0'

# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

gem 'kaminari'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

gem 'web-console', group: :development

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'byebug'
  gem 'ruby-graphviz'
  gem 'rspec-rails'
  gem 'spring'
  gem 'sqlite3', '~> 1.3', '< 1.4'
end

group :development do
  gem 'bcrypt_pbkdf'
  gem 'rbnacl', '< 5.0'
  gem 'rbnacl-libsodium'
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
