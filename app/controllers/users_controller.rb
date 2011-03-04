require 'simple-navigation'
class UsersController < ApplicationController
  def index
    @user = current_user
  end
end
