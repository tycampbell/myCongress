class PoliticiansController < ApplicationController
  
  before_filter :check_administrator_role, :except => [:index, :show, :show_by_username]
  # GET /politicians
  # GET /politicians.xml
  def index
    @politicians = Politician.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @politicians }
    end
  end

  # GET /politicians/1
  # GET /politicians/1.xml
  def show
    @politician = Politician.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @politician }
    end
  end
  
  def show_by_username
    index = params[:username].index('_')
    first = params[:username][0,index]
    last = params[:username][index+1,params[:username].length]
    @politician = Politician.find(:first, :conditions => ['last_name = ? AND first_name = ?',last,first])
    
    respond_to do |format|
      format.html {render :action => 'show'}
      format.xml  { render :xml => @politician }
    end
  end

  # GET /politicians/new
  # GET /politicians/new.xml
  def new
    @politician = Politician.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @politician }
    end
  end

  # GET /politicians/1/edit
  def edit
    @politician = Politician.find(params[:id])
  end

  # POST /politicians
  # POST /politicians.xml
  def create
    @politician = Politician.new(params[:politician])
    @politician.party.capitalize!
    @politician.position.capitalize!
    
    #Create corresponding user
    user = User.new(:username => (@politician.first_name + "_"+ @politician.last_name),
                    :password => (@politician.first_name + "_"+ @politician.last_name),
                    :password_confirmation =>(@politician.first_name + "_" + @politician.last_name),
                    :email => (@politician.first_name + "_" + @politician.last_name + "@something.com"))
    user.add_role('Politician')   
    user.enabled = false   
    user.save!
                    
    @politician.user_id = user.id

    respond_to do |format|
      if @politician.save
        flash[:notice] = 'Politician was successfully created.'
        format.html { redirect_to(@politician) }
        format.xml  { render :xml => @politician, :status => :created, :location => @politician }
      else
        flash[:notice] = 'There was an error creating the politician.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @politician.errors, :status => :unprocessable_entity }
      end
    end
    
  
  end

  # PUT /politicians/1
  # PUT /politicians/1.xml
  def update
    @politician = Politician.find(params[:id])

    respond_to do |format|
      if @politician.update_attributes(params[:politician])
        flash[:notice] = 'Politician was successfully updated.'
        format.html { redirect_to(@politician) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @politician.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /politicians/1
  # DELETE /politicians/1.xml
  def destroy
    @politician = Politician.find(params[:id])
    @politician.destroy

    respond_to do |format|
      format.html { redirect_to(politicians_url) }
      format.xml  { head :ok }
    end
  end
end
