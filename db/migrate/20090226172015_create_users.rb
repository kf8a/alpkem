class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :openid_identifier
      t.string :persistence_token
      t.string :password_salt, :default => nil, :null => true
      t.datetime :last_request_at
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
