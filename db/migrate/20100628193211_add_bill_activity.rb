class AddBillActivity < ActiveRecord::Migration
  def self.up
    add_column :bills, :activity, :double
  end

  def self.down
    remove_column :bills, :activity
  end
end
