class ApplicationController < ActionController::Base
  respond_to :json
  protect_from_forgery
  # Override the default devise signin/signout process
  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope      = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    # redirect_to stored_location_for(scope) || after_sign_in_path_for(resource)

    respond_to do |format|
      format.html  { redirect_to('/users') }
      format.json  { render :json => {:status => :signed_in} }
    end

  end
end