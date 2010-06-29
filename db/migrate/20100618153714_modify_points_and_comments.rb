class ModifyPointsAndComments < ActiveRecord::Migration
  def self.up
    remove_column :points, :best
    remove_column :points, :score
    remove_column :points, :pos_votes
    remove_column :points, :total_votes
    
    add_column :comments, :can_vote, :boolean, :default => true
  end

  def self.down
    add_column :points, :best
    add_column :points, :score
    add_column :points, :pos_votes
    add_column :points, :total_votes
    
    remove_column :comments, :can_vote
  end
end
