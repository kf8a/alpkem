# Represents a replication of a treatment. 
# Together with the treatment it usually denotes a plot
class Replicate < ActiveRecord::Base
  belongs_to :study
end
