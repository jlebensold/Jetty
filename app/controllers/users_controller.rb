require 'simple-navigation'
class UsersController < ApplicationController
  def index
    @user = current_user
    @user.checkfolder
  end
end
