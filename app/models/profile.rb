class Profile < ActiveRecord::Base
  
  belongs_to :user
  
  #Cache Money
  is_cached(:repository => $cache)
  index [:user_id, :id]
  
  validates_length_of :state, :maximum => 2, :allow_nil => true
  validates_length_of :zip, :within => 5..9, :allow_nil => true
  
end
