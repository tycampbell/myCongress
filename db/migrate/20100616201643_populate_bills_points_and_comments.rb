class PopulateBillsPointsAndComments < ActiveRecord::Migration
  
  class Stuff
    
    def initialize
      @users = User.find(:all)
      @random = @users.length
      @useless_comments = ["First","I like the bill", "I don't like the bill", "Why would anyone think this is a good bill?","This is a silly bill","This is the worst bill ever", "I love this bill so much!","I want this bill passed now!","Why has this never been passed before?","OMG GUIYZ THIS ARE AMAZING LOLOL"]
      @useless_replies = ["You suck", "You're stupid", "Why would we listen to you?","You have no life", "That is a good point", "I like this pint", "I don't think this is a good point", "Please GTFO, troll", "No you", "Meh", "I've heard better replies from dirt", "This comment belongs on youtube...","Remember when myCongress was good?","This is the cancer that is killing myCongress", "LOL","ROFLCOPTER","Lulz","Upboat!","Why would you say that?","*sigh*","This is why we can't have nice things","Seriously, GTFO", "I like you're idea but it needs more work","Could use a little more thought","Come on...","That was uncalled for","If this post ends in a ...oh wait", "Why isn't this at the top?","Downvotes incoming...","Downvote for inaccuracy","Pwned","Owned","loser...","Get off the intarwebz","Wikipedia says Congress is the governing body of the legislative branch of the government"]
      @random_reply = @useless_replies.length
      @random_comment = @useless_comments.length


      #Bills:
      create_bill('Clean River Act',
                ["This will help clean rivers", "This will create jobs!"],
                ["This is a money sink", "Actually increases pollution"])
      create_bill('Military is Making you Poor',
                ["Lowers Taxes!", "Reduces military budget and decreases federal debt"],
                ["Makes our country weaker", "Only affects the lowest tax bracket"])
                
      create_bill('Wall Street Fair Share Act',
                ["This is fair"],
                ["This is grossly unfair towards"])
                
      create_bill('Fire Sprinkler Incentive Act of 2010',
                  ["Fire sprinklers should be everywhere"],
                  ["Waste of money"])
      create_bill('Wall Street Bonus Tax Act',
                  ["We bailed them out and they still get massive bonuses?"],
                  ["Why should they be so massively tax? It's unfair!"])
      create_bill('Business Should Mind Its Own Business Act',
                  ["Business *should* mind its own business"],
                  ["This is meaningless"])
      create_bill('Tobacco Tax Parity Act of 2010',
                  ["Keep those tobacco taxes coming"],
                  ["No more taxes on tobacco are necessary!"])
                                                      
                      
                

                
      
      
    end
    
    def create_bill(name, positive, negative)
      bill = Bill.new( :name => name,
                         :number => -1 * (rand(95)+5),
                         :summarized => false,
                         :finished => false)
      bill.save

      #Create 5 comments with replies
      self.generate_random_comments(bill.id,3)

      #Create 2 positive points with replies
      self.generate_points(bill.id, true, positive)

      #Create 2 negative points with replies
      self.generate_points(bill.id, false, negative )
      
      
    end
    
    def generate_points(bill_id, is_positive, texts)
      for i in 0...texts.length
        temp = create_point(texts[i], is_positive, bill_id)
        generate_random_replies(temp.id)
      end
    end

    def generate_random_comments(bill_id, num)
      (1..num).each do
        temp = create_comment(random_comment, bill_id)
        #generate replies
        generate_random_replies(temp.id)
      end
    end

    def generate_random_replies(temp_id)
      #Create 1 to 3 replies
      (1..(rand(3)+1)).each do
          temp2 = reply_to_comment(random_reply, temp_id) if temp_id
          #create 0 to 2 replies to that comment
          (0..rand(3)).each do
            temp3 = reply_to_comment(random_reply, temp2.id) if temp2
            #create 0 to 1 replies to that comment
            (0..rand(2)).each do
              temp4 = reply_to_comment(random_reply, temp3.id) if temp3
            end
          end
        end
    end

    def create_comment(text, bill_id)
      comment = Comment.new(  :text => text,
                              :user_id => @users[rand(@random)].id,
                              :bill_id => bill_id )
      comment.save!

      return comment
    end

    def reply_to_comment(text, comment_id)
      comment = Comment.new(  :text => text,
                              :user_id => @users[rand(@random)].id,
                              :parent_id => comment_id )
      comment.save!

      return comment
    end

    def create_point(text, is_positive, bill_id)
      comment = Comment.new(  :text => text,
                              :user_id => @users[rand(@random)].id,
                              :bill_id => bill_id )
      comment.save

      point = Point.new(      :text => text,
                              :is_positive => is_positive,
                              :user_id => @users[rand(@random)].id,
                              :bill_id => bill_id,
                              :comment_id => comment.id )
      point.save

      comment.point_id = point.id
      comment.save

      return comment
    end
    def random_comment
      return @useless_comments[rand(@random_comment)]
    end
    def random_reply
      return @useless_replies[rand(@random_reply)]
    end
  end
  
  class Destroy
    def initialize(bill_id)
      @bill = Bill.find(bill_id)

      @summaries = Summary.find(:all,
                    :conditions => ['bill_id = ?', bill_id])
      @summaries.each do |summary|
        summary.destroy
      end

      @comments = Comment.find(:all,
                    :conditions => ['bill_id = ?', bill_id])
      @comments.each do |comment|
        comment_children_destroy(comment.id)
        comment.destroy
      end

      @points = Point.find(:all,
                    :conditions => ['bill_id = ?', bill_id])
      @points.each do |point|
        point.destroy
      end

      @bill.destroy
    end

    def comment_children_destroy(comment_id)
      @comments = Comment.find(:all,
                    :conditions => ['parent_id = ?', comment_id])
      @comments.each do |comment|
        comment_children_destroy(comment.id)
        comment.destroy
      end
    end
  end
  
  def self.up
    
    #For some reason I can't run other methods,
    # so stuff is up in that class and this just calls it
    everything_in_above_class = Stuff.new
    
  end

  def self.down
    @bills = Bill.find(:all, :conditions => ['number < ?', 0])
    @bills.each do |bill|
      Destroy.new(bill.id)
    end
  end
  
  
end
