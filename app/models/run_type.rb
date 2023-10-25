# frozen_string_literal: true

# Main model in this app. Runs represent a set of measurements
class RunType < ActiveRecord::Base
  has_many :runs
end
