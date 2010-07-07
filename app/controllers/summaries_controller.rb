class SummariesController < ApplicationController
  
  #before_filter :check_if_bill_is_finished, :only => [:new, :edit, :edit_archived]
  before_filter :login_required, :except => [:index, :show]
  
  def index
    #This is the version history action!
    @bill = Bill.find(params[:bill_id])
    #List all summaries created for the bill in descending creation date order
    @summaries = Summary.paginate(
                  :page => params[:page],
                  :include => :user,
                  :order => 'created_at DESC',
                  :conditions => ['bill_id = ?', @bill.id.to_i])
  end
  
  def show
    @summary = Summary.find(params[:id])
    @bill = @summary.bill
  end
  
  def new
    @bill = Bill.find(params[:bill_id])
    @summary = Summary.new
  end
  
  def edit
    #This will always grab the most recent summary
    @bill = Bill.find(params[:bill_id])
    @summary = @bill.summary
    
    render :action => 'new'
  end
  
  def edit_archived
    #This grabs a previous summary that is currently not set as the bill's summary
    @summary = Summary.find(params[:id])
    @bill = @summary.bill
    
    render :action => 'new'
  end
  
  def create
    #edit, edit_archive, and new create new summaries
    #and then set the bill's summary to the newly created one
    
    @bill = Bill.find(params[:bill_id])
    
    @summary = Summary.new
    @summary.text = params[:summary][:text]
    @summary.comment = params[:summary][:comment]
    @summary.user_id = logged_in_user.id
    @summary.bill_id = @bill.id
    @summary.tag_list = params[:summary][:tags].downcase
    
    #We need to add a warning if this is a reverted edit
    #so check if there is a parent (we're editing something)
    #and that the parent is not the current summary of the bill
    if params[:parent_id] and @bill.summary.id != params[:parent_id]
      #Some edit is getting reverted over!
      #Add warnings
      add_warnings(params[:parent_id])
    end
    
    if @summary.save!
      #If the new summary is successfully created,
      # update the bill's current summary to point to the new one
      @bill.summarized = true unless @bill.summarized # set true if not true already
      @bill.summary_id = @summary.id
      @bill.tag_list = @summary.tag_list
      if @bill.save
        respond_to do |wants|
          flash[:notice] = 'Summary successfully added'
          wants.html { redirect_to bill_path(@bill) }
          wants.xml { render :xml => @article.to_xml } 
        end
      else
        flash[:notice] = 'There was an error updating the bill'
        redirect_to bill_path(@bill)
      end
    else
      flash[:notice] = 'There was an error creating your summary'
      render :action => 'new'
    end
  end
  
  
  #--------PRIVATE---------
  
  #Adds warnings if someone reverts over multiple edits
  def add_warnings(parent_id)
    parent = Summary.find(params[:parent_id])
    
    #grab all summaries of the bill in reverse chronological order
    summaries = Summary.find(:all,
                              :conditions => ['bill_id = ?', @bill.id],
                              :order => 'created_at DESC')
       
    #we find the depth of the summaries being reverted over by looping
    #through the summaries until the parent (the last 'good' one is found)
    index = summaries.index(parent)
    if index.nil?
      error shit aint here
    end
    
    depth = 0                  
    summaries.values_at(0...index).each do |summary|
  
        depth+=1
        #if the check is not the parent, add a warning
        warning = Warning.new(:user_id => summary.user_id,
                              :reported_by_id => logged_in_user.id,
                              :type_id => summary.id,
                              :type_class => 'summary')
        warning.revert_level = depth
        
        begin
          #This is in case the database throughs an error if it already exists
          warning.save
        rescue Exception => e
          #If it is caught, we do nothing as lower depths are worse
          #and the depth can't get lower
          
        end
      end
  end
  
end
