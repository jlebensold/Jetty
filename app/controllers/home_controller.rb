class HomeController  < ApplicationController
  before_filter :authenticate_user!, :only => :token

  def token
  end

  def signup
    @publisher = Publisher.new(params[:publisher])
    
  end

  def create
    @publisher = Publisher.new(params[:publisher])
    
    if (@publisher.save)
      redirect_to "/almostdone"
    else
      render :action => "signup"
    end
  end
  def almostdone
  end
  def index
  end
end
