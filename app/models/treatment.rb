# frozen_string_literal: true

# Together with a replicate, this usually represents a plot.
class Treatment < ActiveRecord::Base
  belongs_to :study
end
