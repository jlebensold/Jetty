class ZencoderController < ApplicationController
  protect_from_forgery :except => :index
  def index
    if params["job"]["state"] == "finished"
      c = Content.find(params[:id])
      c.status = Content::STATUS_COMPLETE
      c.save!
    end
    render :json => {:success => true, :id => params[:id]}
  end
end
