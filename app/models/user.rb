# frozen_string_literal: true

# Represents the people logging in and using the application.
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable,
  # :timeoutable and :omniauthable
  devise :rememberable, :database_authenticatable, :recoverable
end
