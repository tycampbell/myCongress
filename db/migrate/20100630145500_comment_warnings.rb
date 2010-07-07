class CommentWarnings < ActiveRecord::Migration
  def self.up
    add_column :comments, :warnings, :int, :default => 0, :null => false
    add_column :comments, :deleted, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :comments, :warnings
    remove_column :comments, :deleted
  end
end
