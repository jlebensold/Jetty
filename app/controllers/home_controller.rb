class HomeController  < ApplicationController
  before_filter :authenticate_user!, :only => :token
  layout "marketing"
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
     logger.info "current user"
      logger.info current_user

  end
end
