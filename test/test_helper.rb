# coding: UTF-8

ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
    
  
  
  Factory.define :user do |u|
  end

  Factory.define :analyte do |a|
    a.name  "NO3"
    a.unit  "ppm"
  end
  
  Factory.define :sample do |s|
    s.sample_type_id  1
    s.plot_id         1
    s.sample_date     Date.today
  end
  
  Factory.define :cn_sample do |s|
    s.cn_plot         "Testplot"
    s.sample_date     Date.today
  end  
  
  Factory.define :measurement do |m|
#    m.association     :run
#    m.sample          Factory.create :sample       
    m.association     :sample
#    m.analyte         Factory.create :analyte
    m.association     :analyte
    m.amount          0.5
  end

  Factory.define :cn_measurement do |m|
    m.run_id          2
    m.cn_sample       Factory.create :cn_sample       
    m.analyte         Factory.create :analyte
    m.amount          0.5
  end

  Factory.define :run do  |r|
    r.run_date          Date.today
    r.sample_date       Date.today
    r.sample_type_id    1
    r.after_build {|run| Factory.create(:measurement, :run_id => run.object_id)}
#    r.association       :measurements, :factory => :measurement
  end
end
