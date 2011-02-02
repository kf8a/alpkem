ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'shoulda'
require 'factory_girl'

def find_or_factory(model, attributes = Hash.new)
  model_as_constant = model.to_s.titleize.gsub(' ', '').constantize
  object = model_as_constant.where(attributes).first
  object ||= Factory.create(model.to_sym, attributes)

  object
end

class ActiveSupport::TestCase
  #include Devise::TestHelpers
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  setup :load_data_if_necessary

  protected

  def load_data_if_necessary
    if Plot.find_by_name("DCL01S01010").blank?
      load "#{Rails.root}/db/seeds.rb"
    end
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

