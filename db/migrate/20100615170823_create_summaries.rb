class CreateSummaries < ActiveRecord::Migration
  def self.up
    create_table :summaries do |t|
      t.integer :bill_id
      t.integer :user_id
      t.text :text
      t.string :comment
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :summaries
  end
end
