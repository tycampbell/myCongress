class Bill < ActiveRecord::Base
  
  #For paginate, limit pages to # per page:
  @@per_page = 3
  
  acts_as_voteable
  acts_as_taggable
  
  #Cache Money:
  is_cached(:repository => $cache)
  index :summarized_at
  index [:summarized, :finished]
  
  has_many :comments, :dependent => :delete_all
  has_many :points, :dependent => :delete_all
  belongs_to :summary, :dependent => :delete
  
  has_many :best_comments, :class_name => 'Comment', :order => 'best DESC'
  
  validates_presence_of :name
  
  validates_length_of :name, :maximum => 255
  
  before_save [:update_times, :update_activity]
  
  def update_times
    self.summarized_at = Time.now if summarized == true
    if finished == true
      self.finished_at = Time.now
      disable_comments
    end
  end
  
  def update_activity
    date = Time.gm(2005,"dec",8,7,46,43).to_f #Reddit's beginning
    t = self.created_at.to_f - date
    x = self.total_votes
    z = 1 + x
    self.activity = Math.log10(z) + t / 45000
  end
  
  def disable_comments
    self.comments.each do |comment|
      disable_comment(comment)
    end
  end
  
  def disable_comment(comment)
    comment.children.each do |com|
      disable_comment(com)
    end
    comment.can_vote = false
    comment.save
  end
  
  def tag_counts
    self.find(:all).collect{|bill| bill.summary if bill.summary}.tag_counts
  end
  
end
