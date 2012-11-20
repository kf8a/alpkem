class Station < ActiveRecord::Base
  has_many :plots
  # attr_accessible :title, :body
end
