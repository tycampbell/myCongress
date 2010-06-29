class CreateBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.string :name, :null => false
      t.integer :number, :null => false
      t.integer :summary_id
      t.integer :pos_votes, :default => 0
      t.integer :total_votes, :default => 0
      t.boolean :summarized, :default => false
      t.boolean :finished, :default => false
      t.datetime :created_at
      t.datetime :summarized_at
      t.datetime :finished_at
    end
  end

  def self.down
    drop_table :bills
  end
end
