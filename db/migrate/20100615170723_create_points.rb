class CreatePoints < ActiveRecord::Migration
  def self.up
    create_table :points do |t|
      t.integer :bill_id
      t.integer :user_id
      t.integer :comment_id
      t.text :text
      t.integer :best, :default => 0
      t.integer :score, :default => 0
      t.integer :pos_votes, :default => 0
      t.integer :total_votes, :default => 0
      t.boolean :is_positive
      t.timestamps
    end
  end

  def self.down
    drop_table :points
  end
end
