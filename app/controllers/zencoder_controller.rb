class ZencoderController < ApplicationController
  protect_from_forgery :except => :index
  def index
    logger.info "encoding complete:" + params[:id].to_s
    object = ActiveSupport::JSON.decode(request.body.read)
    logger.info object
    if object["job"]["state"] == "finished"
      c = Content.find(params[:id])
      c.status = Content::STATUS_COMPLETE
      c.save!
    end
    render :json => {:success => true, :id => params[:id]}
  end
end
