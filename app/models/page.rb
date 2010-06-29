class Page < ActiveRecord::Base
  validates_presence_of :title, :body
  
  validates_length_of :title, :within => 3..255
  validates_length_of :body, :maximum => 10000
  validates_length_of :permalink, :within => 3..255
  
  validates_uniqueness_of :permalink
  
  
  #The following methods make sure that the permalink entered
  #is clean and allowed in urls, so alphanumeric only
  
  def before_create
    @attributes['permalink'] = @attributes['permalink'].downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
  end
  
  def before_update
    @attributes['permalink'] = @attributes['permalink'].downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
  end
  
end
