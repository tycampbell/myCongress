class CreateWarnings < ActiveRecord::Migration
  def self.up
    create_table :warnings do |t|
      t.integer :user_id
      t.integer :reported_by_id
      t.integer :type_id
      t.string :type
      t.integer :revert_level
      t.timestamps
    end
    
    add_column :users, :warnings_count, :integer, :null => false, :default => 0
    
    #To make it so a person can only report something once
    add_index :warnings, ["reported_by_id", "type_id"], :unique => true, :name => "unique_one_report_only"
    
  end

  def self.down
    drop_table :warnings
    
    remove_column :users, :warnings_count
  end
end
