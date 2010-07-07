module LoginSystem
  protected

  #Check the session and see if that user exists
  def is_logged_in? 
    @logged_in_user = User.find(session[:user]) if session[:user]
  end

  #Returns the user object if logged in, nil otherwise
  def logged_in_user 
    return @logged_in_user unless @logged_in_user.nil?
    return @logged_in_user if is_logged_in?
  end

  #used to log the user in
  def logged_in_user=(user) 
    if !user.nil?
      session[:user] = user.id
      @logged_in_user = user 
    end
  end
  
  #allows these helper methods to be used in views
  def self.included(base) 
    base.send :helper_method, :is_logged_in?, :logged_in_user
  end 
  
  #used to see if a user has the specified role
  def check_role(role) 
    unless is_logged_in? && @logged_in_user.has_role?(role)
      flash[:error] = "You do not have the permission to do that."
      redirect_to '/'
    end
  end
  
  def check_administrator_role 
    check_role('Administrator')
  end
  
  def check_moderator_role
    check_role('Moderator')
  end
  
  def check_politician_role
    check_role('Politician')
  end
  
  def login_required(location = :index)
    unless is_logged_in?
      flash[:error] = "You must be logged in to do that."
      respond_to do |format|
        format.html {
                  if params[:bill_id]
                    redirect_to bill_path(params[:bill_id])
                  else
                    redirect_to '/'
                  end}
        format.js  {}
        format.xml  { render :xml => @bills }
      end
    end
  end
  
end