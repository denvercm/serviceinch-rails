class ApplicationController < ActionController::Base

  include AuthenticatedSystem
  protect_from_forgery
  before_filter :login_required

end
