require 'rubygems'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require "#{Rails.root}/db/seeds.rb"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

def find_or_factory(model, attributes = Hash.new)
  model_as_constant = model.to_s.titleize.gsub(' ', '').constantize
  object = model_as_constant.where(attributes).first
  object ||= FactoryGirl.create(model.to_sym, attributes)

  object
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.mock_with :rspec

  config.use_transactional_fixtures = true
end
