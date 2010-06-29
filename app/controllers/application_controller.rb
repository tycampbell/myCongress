# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Pick a unique cookie name to distinguish our session data from others' 
  session :session_key => '_mycongress_session_id' 
  
  #lib/login_system.rb and voting_system.rb methods
  include LoginSystem
  include VotingSystem
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
