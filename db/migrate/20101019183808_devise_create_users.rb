class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      t.datetime :remember_created_at

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
