class AddUserKarmaAndAnswers < ActiveRecord::Migration
  def self.up
    add_column :users, :karma, :int, :default => 0
  end

  def self.down
    remove_column :users, :karma
  end
end
