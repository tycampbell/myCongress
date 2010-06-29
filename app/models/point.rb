class Point < ActiveRecord::Base
  
  acts_as_voteable
  
  #Cache Money
  is_cached(:repository => $cache)
  index :bill_id
  
  belongs_to :user
  belongs_to :bill
  belongs_to :comment
  
  validates_length_of :text, :within => 1..5000
  
end
