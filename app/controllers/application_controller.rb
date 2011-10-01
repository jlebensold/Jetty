class ApplicationController < ActionController::Base
  respond_to :json, :html
  protect_from_forgery

  # Override the default devise signin/signout process  
  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope      = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope    
    sign_in(scope, resource) unless warden.user(scope) == resource
    
    # redirect_to stored_location_for(scope) || after_sign_in_path_for(resource)
    
    
    respond_to do |format|
      format.html  { redirect_to('/') }
      format.json  { render :json => {:status => :signed_in, :email => current_user.email.to_s, :name => current_user.name.to_s} }
    end

  end
  
  helper_method :current_user
  helper_method :user_signed_in?

  private  
    def current_user  
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]  
    end
    
    def user_signed_in?
      return 1 if current_user 
    end
      
end