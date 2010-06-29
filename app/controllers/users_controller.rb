class UsersController < ApplicationController
  
  before_filter :check_administrator_role, :only => [:index, :destroy, :enable]
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    if @user.has_role('Politician')
      redirect_to :controller => 'politicians', :action => 'show'
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def show_by_username
    @user = User.find_by_username(params[:username])
    respond_to do |format|
      format.html {render :action => 'show'}
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    #Note: Only the logged_in_user can edit a user
    #and he can edit only his own profile
    @user = logged_in_user
    if @user.nil?
      redirect_to (:index)
    else
      #profile may be nil if the user has never filled it out
      @profile = @user.profile || Profile.new()
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        self.logged_in_user = @user
        flash[:notice] = 'Your account has been created.'
        format.html { redirect_to index_url }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(logged_in_user)

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(user_path(@user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])

    if @user.update_attribute(:enabled, false)
      flash[:notice] = 'User disabled'
    else
      flash[:notice] = 'There was a problem disabling this user'
    end

    respond_to do |format|
        format.html { redirect_to(users_url) }
        format.xml  { head :ok }
    end
  end
  
  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      flash[:notice] = "User enabled"
    else
      flash[:error] = "There was a problem enabling this user."
    end
    respond_to do |format|
        format.html { redirect_to(users_url) }
        format.xml  { head :ok }
    end
  end
  
  def submit_profile
    @user = logged_in_user
    @profile = Profile.new(params[:profile])
    @profile.user = @user
    
    if @profile.save
      @user.profile_id = @profile.id
      @user.save
      
      flash[:notice] = "Profile successfully updated. Thank you"
      render :action => 'edit'
    else
      flash[:notice] = "There was an error updating your profile"
      render :action => 'edit'
    end
  end
end
