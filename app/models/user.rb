#Represents the people logging in and using the application.
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :openid_authenticatable, :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :remember_me
end
