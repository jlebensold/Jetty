class ContentsController < ApplicationController
  def index
    @contents = Content.all

  end

  def show
    @content = Content.find(params[:id])
  end

  def new
    @content = Content.new
    @content.creator = User.find(session[:user_id])
    @content.save()
  end
  def postprocess
    @content = Content.find(params[:id])
    @content.after_s3
    render :json => {:status => "OK"}
  end
  def edit
    @content = Content.find(params[:id])
  end

  def save
    @content = Content.find(params[:id])
    if @content.update_attributes(params[:content])
      if (params[:subcontent])
        params[:subcontent].each { |key,item|
          Url.new(:parent => @content , :title => item[:title], :meta => item[:value])
        }
      end

      render :json => {:status => "OK"}
    else
      render :json => {:status => "FAIL"}
    end


  end

  def upload
      @content = Content.find(params[:id])
      @content.value = params[:Filedata]
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
