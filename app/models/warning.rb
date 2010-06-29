class Warning < ActiveRecord::Base
  
  belongs_to :user, :counter_cache => true
  
  #Cache Money
  is_cached(:repository => $cache)
  index :user_id
  
end
