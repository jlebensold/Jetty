class SessionsController < Devise::SessionsController
  protect_from_forgery :except => [:create, :destroy]

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
#    respond_with resource, :location => redirect_location(resource_name, resource)

    #set the user id in session so that omniauth is integrated
    session[:user_id] = session['warden.user.user.key'][1][0]
    respond_to do |format|
      format.json  { render :json => {:status => :signed_in, :user => current_user.as_jsonpreview} }
      format.html  { redirect_to('/') }
      
    end

  end
  def destroy
#    super
    logger.info '============ need to kill session!'
    session[:user_id] = nil
    session[:service_id] = nil
    session.delete :user_id
    session.delete :service_id

    reset_session

    redirect_to root_url
#    reset_session
  end
end