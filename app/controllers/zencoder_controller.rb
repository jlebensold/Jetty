class ZencoderController < ApplicationController
  def index
    logger.info "encoding complete:" + params[:id].to_s
    if params[:job][:state] == "finished"
      c = Content.find(params[:id])
      c.status = Content::STATUS_COMPLETE
      c.save!
    end
    render :json => {:success => true, :id => params[:id]}
  end
end
