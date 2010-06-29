class CreatePoliticians < ActiveRecord::Migration
  def self.up
    create_table :politicians do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :party
      t.string :position
      t.string :state
      t.string :district
      t.timestamps
    end
  end

  def self.down
    drop_table :politicians
  end
end
