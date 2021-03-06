class CommentsController < ApplicationController
  
  #after_filter :rebuild_cache, :only => [:create,:reply,:upvote,:downvote,:change_to_upvote,:change_to_downvote]
  before_filter :check_moderator_role, :only => [:delete]
  before_filter :comment_login_required, :except => [:index]
  #caches_action :index
  
  def index
    #Shows comments to the bill specified
    #@bill = Bill.find(params[:bill_id])
    @bill = Bill.find(params[:bill_id],
                          :include => {:best_comments => :user})
    @comments = @bill.best_comments
    #@comments = Comment.find(:all,
    #                :conditions => ['bill_id = ?', @bill.id] ,
    #                :order => 'best DESC',
    #                :include => :user)
    

    respond_to do |format|
      format.html # discussion.html.erb
      format.xml  { render :xml => @bill }
    end
  end
  
  def create
    #creates a new comment that is directly commenting on the Bill
    # (therefor it has a bill_id but not a parent)
    
    @bill = Bill.find_by_id(params[:bill_id])
    @comment = Comment.new(:text => params[:new_comment][:text],
                          :user_id => logged_in_user.id,
                          :bill_id => @bill.id)
                          
    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Your comment was added'
        format.html { redirect_to(bill_comments_path(@bill)) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        flash[:notice] = 'There was an error adding your comment'
        format.html { redirect_to(bill_comments_path(@bill)) }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  #
  ## - Reply Methods
  #
  
  def request_reply
    #Sends the form through AJAX so they can reply to a comment
    
    @comment =  Comment.find(params[:id])
    @bill = Bill.find(params[:bill_id])
    
    render :partial => 'comments/reply', :object => @comment
  end

  def reply
    #adds a new comment that replies to another comment
    # (therefor, it has no bill_id but does have a parent)
    
    @comment = Comment.new(:text => params[:new_comment][:text],
                          :user_id => logged_in_user.id,
                          :parent_id => params[:parent_id])
                          
    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Your reply was added'
        format.html { redirect_to(bill_comments_path(params[:bill_id])) }
        format.xml  { render :xml => comment, :status => :created, :location => comment }
      else
        flash[:notice] = 'There was an error adding your reply'
        format.html { redirect_to(bill_comments_path(params[:bill_id])) }
        format.xml  { render :xml => comment.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  #--
  #Voting Methods:
  #--
  
  def upvote
    @comment = Comment.find(params[:id])
    
    #comment_point_vote method in VotingSystem
    comment_point_vote(true)
    
    render :partial => 'comments/comment_info', :object => @comment
  end
  
  def downvote
    @comment = Comment.find(params[:id])
  
    comment_point_vote(false)
    
    render :partial => 'comments/comment_info', :object => @comment
  end
  
 def change_to_upvote
   @comment = Comment.find(params[:id])
 
   comment_point_change_vote
   comment_point_vote(true)
   
   render :partial => 'comments/comment_info', :object => @comment
  end
  
  def change_to_downvote
     @comment = Comment.find(params[:id])

     comment_point_change_vote
     comment_point_vote(false)

     render :partial => 'comments/comment_info', :object => @comment
  end
  def comment_login_required
    unless is_logged_in?
      @comment = Comment.find(params[:id])
      flash[:error] = "You must be logged in to do that."
      render :text => 'Please Login or Register'
    end
  end
  
  #
  ## - Report methods
  #
  
  def request_report
    @comment =  Comment.find(params[:id])
    
    render :partial => 'comments/report', :object => @comment
  end
  
  def report
    @comment = Comment.find(params[:id])
    
    warning = Warning.new(:user_id => @comment.user_id,
                          :reported_by_id => logged_in_user.id,
                          :type => @comment,
                          :type_class => 'comment')
    warning.save
    
    @comment.warnings += 1
    @comment.save
    
    render :partial => 'comments/reported'
    
    #If they try to report the same thing, we have to rescue it
    #Because the database will throw an error
    #Users can't report the same thing twice!
    #This is working as intended
    #rescue
    
   # render :partial => 'comments/reported'
    
  end
  
  def request_delete
    @comment =  Comment.find(params[:id])
    @bill = params[:bill_id]
    
    render :partial => 'comments/delete', :object => @comment
  end
  
  def delete
    
    #Comments aren't destroyed, merely an attribute is updated that makes
    #the list not show the user or text of the comment
    #This preserves the tree structure
    
    @comment = Comment.find(params[:id])
    @bill = Bill.find(params[:bill_id])
    
    if @comment.update_attribute(:deleted, true)
      flash[:notice] = "Comment successfully deleted"
      render :partial => 'comments/comment', :object => @comment
    else
      flash[:notice] = "There was an error deleting the comment"
      render :partial => 'comments/comment', :object => @comment
    end
  end
  
  private
  
  def rebuild_cache
    temp = @comment
    while(!temp.bill)
       temp = Comment.find(temp.parent_id)
    end
    #expire_fragment("#{temp.bill.id}_comments")
    #expire_action :action => :index, :bill_id => temp.bill.id
    
    #TODO: Rebuild the cache here so next user doesn't have to wait!
  end
  
end
