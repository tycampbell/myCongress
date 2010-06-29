class Politician < ActiveRecord::Base
  
  belongs_to :user
  
  is_cached(:repository => $cache)
  index [:first_name, :last_name]
  
  
  def shorthand
    self.position[0,3] + ". " + self.first_name + " " + self.last_name + " (" + self.party[0,1] + "-" + self.state + ")"
  end
  
end
