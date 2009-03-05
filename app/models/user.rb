class User < ActiveRecord::Base
    acts_as_authentic :validate_fields=>false
end
