class HomeController  < ApplicationController
  def index
    @current_user = Publisher.new({:email => "jon@lebensold.ca" , :password => "abc123"})
    @current_user.save!
    session[:user_id] = @current_user.id
  end
end
