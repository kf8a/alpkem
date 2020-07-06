# frozen_string_literal: true

# This is supposed to represent a sampling station
# but I don't think it is used anywhere
# TODO: check and remove
class Station < ActiveRecord::Base
  has_many :plots
end
