class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    drop_table :open_id_authentication_associations
    drop_table :open_id_authentication_nonces
    create_table(:users) do |t|
      t.openid_authenticatable
      t.rememberable      

      t.timestamps
    end

    add_index :users, :identity_url, :unique => true
  end

  def self.down
    drop_table :users
  end
end
