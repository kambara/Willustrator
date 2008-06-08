# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  session :session_expires => 365.days.from_now

  #protect_from_forgery :secret => 'b4ad973e3dc206b3f00079d39f0a4623'
end
