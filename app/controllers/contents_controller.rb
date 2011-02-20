class ContentsController < ApplicationController
  # GET /contents
  # GET /contents.xml
  def index
    @contents = Content.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contents }
    end
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
    #logger.info pp(@content) #@content
  end

  def save
    
  end

  def upload
    
  end

  def create

    if params[:Filedata]
      async_upload
    else
      @content = Content.new(params[:content])
      respond_to do |format|
        if @content.save
          format.js
          format.html { redirect_to(@content, :notice => 'Content was successfully created.') }
        else
          format.html { render :action => "new" }
        end
      end
    end
  end
  def async_upload
      @content = Content.new(:value => params[:Filedata])
  end

  # PUT /contents/1
  def update
    @content = Content.find(params[:id]).becomes(Content)
    if params[:Filedata]
      @content.value = params[:Filedata]
    end
    respond_to do |format|
      if @content.update_attributes(params[:content])
        format.xml  { head :ok }
        format.json { head :ok}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @content.errors, :status => :unprocessable_entity }
      end
    end
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
