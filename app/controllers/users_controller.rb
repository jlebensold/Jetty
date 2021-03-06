class UsersController < BasePublisherController
  before_filter :authenticate_user!, :except => [:register]
  def register
    @user = Customer.new
    if @user.update_attributes(params[:user])
      sign_in(:user , @user)
      render :json => {:user => { :email => @user.email},:status => "SUCCESS" , :success => true}
    else
      render :json => {:status => "FAIL", :errors => @user.errors}
    end
  end
  def show
    redirect_to :action => "index", :controller => "home"
  end
  def my_account
    @user = current_user
  end
  def save
    @user = current_user
    @user.paypal_email = params[:publisher][:paypal_email]
    @user.save(:validate => false)
    redirect_to :action => "index"
  end
  def logout
    logger.info 'need to kill session!'
    session[:user_id] = nil
    session[:service_id] = nil
    session.delete :user_id
    session.delete :service_id

    sign_out(current_user) if not current_user.nil? 
    redirect_to :action => "index", :controller => "home"
  end
  def index
    logger.info "asdasd"
    logger.info current_user
    
    @user = current_user
  end

end
