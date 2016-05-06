# Keeps a record of the original data
class DataSource < ActiveRecord::Base
  belongs_to :run

  mount_uploader :data, DataUploader
end
