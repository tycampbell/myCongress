class AccountController < ApplicationController
  def authenticate
    self.logged_in_user = User.authenticate(params[:user][:username], params[:user][:password])

    if is_logged_in? 
      set_cookies
      render 'layouts/reload_menu.rjs'
    else 
      flash[:error] = "I'm sorry; either your username or password was incorrect." 
      render 'layouts/reload_menu.rjs'
    end 
  end
  
  def logout 
    if request.post?
      reset_session
      cookies.delete :login
      flash[:notice] = "You have been logged out." 
    end
    
    render 'layouts/reload_menu.rjs'
  end
  
  def set_cookies
    cookies[:login] = logged_in_user.username
  end
  

end
