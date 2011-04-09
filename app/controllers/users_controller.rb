require 'simple-navigation'
class UsersController < ApplicationController
  def index
    @user = current_user
    @user.checkfolder
  end
  def register
    @user = User.new
    if @user.update_attributes(params[:user])
      sign_in(:user , @user)
      render :json => {:status => "SUCCESS" , :success => true, :user_id => @user.id}
    else
      render :json => {:status => "FAIL"}
    end
    
  end
end
