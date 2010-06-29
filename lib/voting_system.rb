module VotingSystem
  protected
  
  def get_best_rating(votes_for, votes_total)
     if votes_total > 5
       ratio = 1.0*votes_for/votes_total
       return (ratio - 2.0*ratio*(1-ratio)/Math.sqrt(votes_total))*1000.to_i
      else
        return (2*votes_for-votes_total)*100
      end
  end
  
  def comment_point_vote(upvote_or_downvote)

    value = (upvote_or_downvote) ? 1 : -1 

    if logged_in_user.vote(@comment, upvote_or_downvote)
      @comment.score += value
      @comment.total_votes += 1
      @comment.pos_votes += 1 if upvote_or_downvote
      @comment.best = get_best_rating(@comment.pos_votes, @comment.total_votes)
      
      @comment.save!
    end
    
  end
  
  def comment_point_change_vote
    
    
    @vote_comment = Vote.for_voter(logged_in_user).for_voteable(@comment).first
    
    if @vote_comment.vote? == true
      #He voted on the comment, remove total and pos votes
      @comment.score -= 1
      @comment.total_votes -= 1
      @comment.pos_votes -= 1
    else
      #He voted against the comment
      @comment.score += 1
      @comment.total_votes -= 1
    end
    @comment.best = get_best_rating(@comment.pos_votes, @comment.total_votes)
    @comment.save
    
    #Destroy the Vote object
    @vote_comment.destroy
    
      
    
  end
  
end