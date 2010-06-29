class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :parent
      t.integer :bill_id
      t.integer :user_id
      t.integer :point_id
      t.text :text
      t.integer :best, :default => 0
      t.integer :score, :default => 0
      t.integer :pos_votes, :default => 0
      t.integer :total_votes, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
