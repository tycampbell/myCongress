class Comment < ActiveRecord::Base
  acts_as_tree :order => "best DESC"
  acts_as_voteable
  
  #Cache Money
  is_cached(:repository => $cache)
  index [:bill_id, :best], :order => :desc
  index [:parent_id, :best], :order => :desc
  index [:id, :user_id]
  
  belongs_to :user
  belongs_to :bill
  belongs_to :point
  
  validates_length_of :text, :within => 1..5000
  
end
