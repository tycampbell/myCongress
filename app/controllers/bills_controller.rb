class BillsController < ApplicationController
  
  before_filter :check_administrator_role, :only => [:destroy, :update, :admin, :show_admin]
  before_filter :bill_login_required, :only => [:vote_for, :vote_against, :change_vote]
  
  include BillsHelper
  # GET /bills
  # GET /bills.xml
  def index
    #Default Index is Summarized, sorted by summarized at
    @action = 'Summarized'
    order = 'summarized_at DESC'
    conditions = 'summarized=true AND finished=false'
    
    #New Bills, sorted by created at
    if params[:sort] == 'new'
      @action = 'New'
      order = 'created_at DESC'
      conditions = 'summarized=false AND finished=false'
      
    #Finished bills, sorted by when they were finished
    elsif params[:sort] == 'finished'
      @action = 'Finished'
      order = 'finished_at DESC'
      conditions = 'finished=true'
      
    #Activity Based - All unfinished bills sorte by activity
    elsif params[:sort] == 'activity'
      @action = 'Activity-Based'
      order = 'activity DESC'
      conditions = 'finished=false'
    end
    
    @bills = Bill.paginate(
              :page => params[:page],
              :order => order,
              :conditions => conditions,
              :per_page => 3)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bills }
    end
  end
  
  def activity_bills
    @bills = Bill.paginate(
              :page => params[:page],
              :order => 'activity DESC',
              :conditions => 'finished=false',
              :per_page => 3)
    @action = 'Activity-Based'

    respond_to do |format|
      format.html {render :action => 'index'}
      format.xml  { render :xml => @bills }
    end
  end
  
  def new_bills
    order = 'created_at DESC'
    if params[:sort] == 'activity'
      order = 'activity DESC'
    end
    
    @bills = Bill.paginate(
              :page => params[:page],
              :order => order,
              :conditions => 'summarized=false AND finished=false',
              :per_page => 3)
    
    @action = 'New'

    respond_to do |format|
      format.html {render :action => 'index'}
      format.xml  { render :xml => @bills }
    end
  end
  
  def finished_bills
    @bills = Bill.paginate(
              :page => params[:page],
              :order => 'finished_at DESC',
              :conditions => 'finished=true',
              :per_page => 3)

    @action = 'Finished'
    
    respond_to do |format|
      format.html {render :action => 'index'}
      format.xml  { render :xml => @bills }
    end
  end
    

  # GET /bills/1
  # GET /bills/1.xml
  def show
    @bill = Bill.find(params[:id], :include => {:points => :comment})
    
    #points = Point.find(:all,
    #                        :conditions => ['bill_id = ?', @bill.id])
     
    points = @bill.points
                            
    @positive = []
    @negative = []
    points.each do |point|
      if point.is_positive
        @positive << point
      else
        @negative << point
      end
    end
    
    
    #Sort by BEST DESC
    @positive.sort! {|x,y| y.comment.best <=> x.comment.best }
    @negative.sort! {|x,y| y.comment.best <=> x.comment.best }
    
    @pos_more = @positive.length-3
    @neg_more = @negative.length-3
    
    @positive = @positive.values_at(0..[2,@positive.length-1].min)
    @negative = @negative.values_at(0..[2,@negative.length-1].min) 
    
    #Results
    if @bill.finished
      
      #Private method:
      #Creates the charts to display on the finished bill page
      create_and_show_charts
      
    end


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bill }
    end
  end

  # GET /bills/new
  # GET /bills/new.xml
  def new
    @bill = Bill.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bill }
    end
  end

  # GET /bills/1/edit
  def edit
    @bill = Bill.find(params[:id])
  end

  # POST /bills
  # POST /bills.xml
  def create
    @bill = Bill.new(params[:bill])
    @bill.number = params[:bill][:number].to_i || -1

    respond_to do |format|
      if @bill.save
        flash[:notice] = 'Bill was successfully created.'
        format.html { redirect_to(@bill) }
        format.xml  { render :xml => @bill, :status => :created, :location => @bill }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bills/1
  # PUT /bills/1.xml
  def update
    @bill = Bill.find(params[:id])

    respond_to do |format|
      if @bill.update_attributes(params[:bill])
        flash[:notice] = 'Bill was successfully updated.'
        format.html { redirect_to(@bill) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.xml
  def destroy
    @bill = Bill.find(params[:id])
    
    @votes = Vote.for_voteable(@bill)
    @votes.each do |vote|
      vote.destroy
    end
    
    @summaries = Summary.find(:all,
                  :conditions => ['bill_id = ?', params[:id]])
    @summaries.each do |summary|
      summary.destroy
    end
    
    @comments = Comment.find(:all,
                  :conditions => ['bill_id = ?', params[:id]])
    @comments.each do |comment|
      comment_children_destroy(comment.id)
      @votes = Vote.for_voteable(comment)
      @votes.each do |vote|
        vote.destroy
      end
      comment.destroy
    end
    
    @points = Point.find(:all,
                  :conditions => ['bill_id = ?', params[:id]])
    @points.each do |point|
      point.destroy
    end
    
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to(:action => 'admin') }
      format.xml  { head :ok }
    end
  end
  
  def comment_children_destroy(comment_id)
    @comments = Comment.find(:all,
                  :conditions => ['parent_id = ?', comment_id])
    @comments.each do |comment|
      comment_children_destroy(comment.id)
      @votes = Vote.for_voteable(comment)
      @votes.each do |vote|
        vote.destroy
      end
      comment.destroy
    end
  end
  
  #Vote Methods:
  def vote_for
    @bill = Bill.find(params[:id])
    
    if !@bill.finished and logged_in_user.vote_for(@bill)
        @bill.pos_votes += 1
        @bill.total_votes += 1
    
        @bill.save!
    end
    render :partial => 'layouts/votemenu', :object => @bill
  end
  
  def vote_against
    @bill = Bill.find(params[:id])
    
    if !@bill.finished and logged_in_user.vote_against(@bill)
        @bill.total_votes += 1
    
        @bill.save!
    end
    
    render :partial => 'layouts/votemenu', :object => @bill
  end
  
  def change_vote
    @bill = Bill.find(params[:id])
    
    unless @bill.finished
        #Get the vote object
        @vote = Vote.for_voter(logged_in_user).for_voteable(@bill).first
        
        if @vote.vote? == true
          #He voted on the bill, remove total and pos votes
          @bill.total_votes -= 1
          @bill.pos_votes -= 1
        else
          #He voted against the bill
          @bill.total_votes -= 1
        end
        @bill.save
        
        #Destroy the Vote object
        @vote.destroy
    end
    
    render :partial => 'layouts/votemenu', :object => @bill
      
  end
  
  #To update the votemenu correctly, the bill needed it's own special validation method
  def bill_login_required
    unless is_logged_in?
      @bill = Bill.find(params[:id])
      flash[:error] = "You must be logged in to do that."
      render :partial => 'layouts/votemenu', :object => @bill
    end
  end
  
  #These loading methods are terribly inefficient!
  #FIX FIX FIX!
  
  #Loading more points
  def load_more_positive
    @bill = Bill.find(params[:id])
    points = Point.find(:all,
                            :conditions => ['bill_id = ?', @bill.id])
                            
    @positive = []
    @negative = []
    points.each do |point|
      if point.is_positive
        @positive << point
      end
    end
    
    
    #Sort by BEST DESC
    @positive.sort! {|x,y| y.comment.best <=> x.comment.best }
    #@negative.sort! {|x,y| y.comment.best <=> x.comment.best }
    @positive = @positive.values_at(3...@positive.length)
    
    render :partial => 'bills/point', :collection => @positive
  end
  
  def load_more_negative
    @bill = Bill.find(params[:id])
    points = Point.find(:all,
                            :conditions => ['bill_id = ?', @bill.id])
                            
    @positive = []
    @negative = []
    points.each do |point|
      unless point.is_positive
        @negative << point
      end
    end
    
    
    #Sort by BEST DESC
    @negative.sort! {|x,y| y.comment.best <=> x.comment.best }
    @negative = @negative.values_at(3...@negative.length)
    
    render :partial => 'bills/point', :collection => @negative
  end
  
  #ADMIN STUFF---------
  
  def admin
    @bills = Bill.all
    update_bills_activity
  end
  
  #used to show the results:
  #Currently just a testing method
  def show_admin
    @bill = Bill.find(params[:id])
    @votes = @bill.votes

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bill }
    end
  end
  
  
  #-------------PRIVATE
  
  private
  
  #Show Results Page Graphs:

  #Chart creation methods:
  #This is currently more a proof of concept
  
  def create_and_show_charts
    #See if the results are cached
    @demo_chart = Rails.cache.read("#{@bill.id}_demo_chart")
    @repu_chart = Rails.cache.read("#{@bill.id}_repu_chart")
    @inde_chart = Rails.cache.read("#{@bill.id}_inde_chart")
    @all_chart = Rails.cache.read("#{@bill.id}_all_chart")
    @intensity_map = Rails.cache.read("#{@bill.id}_intensity_map")
    
    if @all_chart.nil? #Basically, if ANY are nil, but if one isn't cached most likely none are
    
      @voters = @bill.voters_who_voted
      @democrats = []
      @republicans = []
      @independents = []
    
      @voters.each do |voter|
        party = voter.profile.party if voter.profile
        if party == 1 #Democrat
          @democrats << voter.voted_for?(@bill)
        elsif party == 2 #republican
          @republicans << voter.voted_for?(@bill)
        else # 0 or 3
          @independents << voter.voted_for?(@bill)
        end
      end
    
      @demo_chart = vote_break_down_chart(@democrats,'Democrat Votes')
      @repu_chart = vote_break_down_chart(@republicans,'Republican Votes')
      @inde_chart = vote_break_down_chart(@independents,'Independent Votes')
      @all_chart = vote_break_down_chart(@democrats+@republicans+@independents,'All Votes')
    
      @intensity_map = vote_intensity_map(@voters, 'All Votes', '000000', nil, 1)
      
      Rails.cache.write("#{@bill.id}_demo_chart",@demo_chart)
      Rails.cache.write("#{@bill.id}_repu_chart",@repu_chart)
      Rails.cache.write("#{@bill.id}_inde_chart",@inde_chart)
      Rails.cache.write("#{@bill.id}_all_chart",@all_chart)
      Rails.cache.write("#{@bill.id}_intensity_map",@intensity_map)
      
    end
  end

   def vote_break_down_chart(group, title)

     group_true = group.find_all{|vote| vote == true}.size


     chart = GoogleVisualr::PieChart.new
     chart.add_column('string', 'Vote')
     chart.add_column('number','# of votes')

     chart.add_rows(2)
     chart.set_value(0,0,'Votes For')
     chart.set_value(0,1,group_true)

     chart.set_value(1,0,'Votes Against')
     chart.set_value(1,1,group.size-group_true)

     chart.width = 200
     chart.height = 200
     chart.title = title

     return chart

   end

   def vote_intensity_map(group, title, color, chart, column)

     @state_abbr = get_state_abbr_array

     if chart.nil?
       chart = GoogleVisualr::IntensityMap.new
       chart.add_column('string','','state')
       chart.add_column('number',title, 'a')
       chart.add_rows(50)
       chart.region = 'usa'
       chart.height = 220
       chart.width = 440

       inc = 0
       @state_abbr.each do |abbr|
         chart.set_value(inc, 0, abbr)
         inc += 1
       end
     end
     group_in_state = {}
     #state_abbr is in the bill helper
     @state_abbr.each do |key|
       #CURRENTLY INEFFICIENT, MAKE FASTER
       voters = group.find_all{|g| g.profile.state == key if g.profile }
       count = 0
       voters.each do |voter|
         if voter.voted_for?(@bill)
           count += 1
         else
           count -= 1
         end
       end
       group_in_state.merge!({key => count})

     end

     group_in_state.each do |key,value|
       chart.set_value(@state_abbr.index(key), column, value)
       inc += 1
     end

     return chart


   end
  
  
  
  def update_bills_activity
    @bills = @bills || Bill.all
    @bills.each do |bill|
      bill.update_activity
      bill.save
    end
  end
  
end
