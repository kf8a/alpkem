#Represents the people logging in and using the application.
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :rememberable, :database_authenticatable, :recoverable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :remember_me, :email, :password

  #HACK to make the newer devise work with openid_authenticatable
  attr :encrypted_password
end
