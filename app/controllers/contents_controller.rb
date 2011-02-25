class ContentsController < ApplicationController
  def index
    @contents = Content.all

  end

  def show
    @content = Content.find(params[:id])
  end

  def new
    @content = Content.new
    @content.save()
  end

  def edit
    @content = Content.find(params[:id])
  end

  def save
    @content = Content.find(params[:id])
    if @content.update_attributes(params[:content])
      render :json => {:status => "OK"}
    else
      render :json => {:status => "FAIL"}
    end


  end

  def upload
      @content = Content.find(params[:id])
      @content.value = params[:Filedata]
      @content.status = Content::STATUS_COMPLETE.to_s
      @content.save()
      render :status => 200
  end


  # DELETE /contents/1
  def destroy
    @content = Content.find(params[:id])
    @content.destroy

    respond_to do |format|
      format.html { redirect_to(@content) }
      format.xml  { head :ok }
    end
  end
end
