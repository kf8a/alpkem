class UpgradeOpenid < ActiveRecord::Migration
  def self.up
    add_index :users, :openid_identifier

     # change_column :users, :login, :string, :default => nil, :null => true
     # change_column :users, :crypted_password, :string, :default => nil, :null => true
     # change_column :users, :password_salt, :string, :default => nil, :null => true
  end

  def self.down
  end
end
