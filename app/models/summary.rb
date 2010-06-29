class Summary < ActiveRecord::Base
  cattr_reader :per_page
    @@per_page = 30
  
  acts_as_taggable
  
  #Cache Money
  is_cached(:repository => $cache)
  index :bill_id
  
  belongs_to :bill
  belongs_to :user
  
  validates_presence_of :text
  
  validates_length_of :text, :maximum => 10000
  validates_length_of :comment, :maximum => 255
  
end
