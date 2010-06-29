class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id
      t.integer :party
      t.integer :view
      t.string :city
      t.string :state
      t.integer :zip
      t.timestamps
    end
    
    add_column :users, :profile_id, :int
  end

  def self.down
    drop_table :profiles
    remove_column :users, :profile_id
  end
end
