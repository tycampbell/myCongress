class PointsController < ApplicationController

  before_filter :login_required, :only => [:create, :upvote, :downvote]

  def request_add_positive
    #sends the partial (for the form) that lets the user add a point
    @bill = Bill.find(params[:bill_id])
    
    render :partial => 'points/add_positive', :object => @bill
  end
  
  def request_add_negative
    #sends the partial (for the form) that lets the user add a point
    @bill = Bill.find(params[:bill_id])
    
    render :partial => 'points/add_negative', :object => @bill
  end
  
  def create
    #When creating a Point, a paired Comment is created and they share votes
    # and link to each other.
    
    comment = Comment.new(:text => params[:point][:text],
                          :user_id => logged_in_user.id,
                          :bill_id => params[:bill_id])
    comment.save!                      
    
    point = Point.new(:text => params[:point][:text],
                          :user_id => logged_in_user.id,
                          :bill_id => params[:bill_id],
                          :is_positive => params[:is_positive],
                          :comment_id => comment.id)
    point.save!    
    
    comment.point_id = point.id
    comment.save!  
    
      
      respond_to do |format|
        flash[:notice] = 'Your point was added'
        format.html { redirect_to(bill_url(params[:bill_id])) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      end
      
    #If either the point or comment don't save properly:
    rescue
      
      respond_to do |format|
          flash[:notice] = 'There was an error adding your point'
          format.html { redirect_to(bill_url(params[:bill_id])) }
          format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    
  end
  
  def upvote
      @point = Point.find(params[:id])
      @comment = @point.comment
    
      #comment_point_vote method in VotingSystem
      comment_point_vote(true) unless @point.bill.finished
    
      #update the partial that displays the score to reflect the change
      render :partial => 'comments/comment_info', :object => @point
  end
  
  def downvote
      @point = Point.find(params[:id])
      @comment = @point.comment
      
      comment_point_vote(false) unless @point.bill.finished
      
      #update the partial that displays the score to reflect the change
      render :partial => 'comments/comment_info', :object => @point
  end
  
  
  
end
