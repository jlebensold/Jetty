class SessionsController < Devise::SessionsController
  def create
    super
    #set the user id in session so that omniauth is integrated
    session[:user_id] = session['warden.user.user.key'][1][0]
  end
end