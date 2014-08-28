class DataSource < ActiveRecord::Base
  belongs_to :run

  mount_uploader :data, DataUploader
end
