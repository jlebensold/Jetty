class ApplicationController < ActionController::Base
  respond_to :json

  protect_from_forgery

   def delayed_job_admin_authentication
      # authentication_logic_goes_here
    end

end
