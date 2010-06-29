class CreateBillAndSummaryTagCache < ActiveRecord::Migration
  def self.up
    add_column :summaries, :cached_tag_list, :string
  end

  def self.down
    drop_column :summaries, :cached_tag_list
  end
end
