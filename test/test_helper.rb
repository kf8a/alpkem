# coding: UTF-8
if RUBY_VERSION > "1.9"
  require 'simplecov'
  SimpleCov.start 'rails'
end

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'shoulda'
require 'factory_girl'

Dir.glob(Rails.root.to_s + "/test/factories/*.rb").each do |factory|
  require factory 
end

class ActiveSupport::TestCase
  #include Devise::TestHelpers
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  setup :load_seeds

  protected

  def load_seeds
    load "#{Rails.root}/db/seeds.rb"
  end
end

class ActionController::TestCase
   include Devise::TestHelpers
end

#Shoulda currently has a bug where they use Test::Unit instead of ActiveSupport
unless defined?(Test::Unit::AssertionFailedError)
  class Test::Unit::AssertionFailedError < ActiveSupport::TestCase::Assertion
  end
end

