class ContentsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @contents = Content.all

  end

  def show
    @content = Content.find(params[:id])
  end

  def new
    @content = Content.new
    @content.creator = User.find(current_user.id)
    @content.save()
    redirect_to "/contents/#{@content.id}/edit"
  end
  def postprocess
    @content = Content.find(params[:id])
    @content.after_s3
    render :json => {:status => "OK"}
  end
  def edit
    @content = Content.find(params[:id])
  end
  def deleteref
    
  end

  def save
    @content = Content.find(params[:id])
    if @content.update_attributes(params[:content])
      if (params[:subcontent])
        sub_ids = params[:subcontent].collect {|k,item| item[:id].to_i}
        ref_ids = @content.references.collect { |i| i.id.to_i }

        #filter out the missing references in the submission:
        ref_ids.keep_if {|rid| sub_ids.select{|sid| sid == rid}.count == 0 }
        ref_ids.each { |filter_id|
          @content.children.find(filter_id).delete
        }
        params[:subcontent].each { |key,item|
          url = Content.find_or_initialize_by_id(item[:id])
          url.update_attributes(item)
          url.parent = @content
          url.save
        }
        #refresh
        @content.children true
      end
      render :json => {:success => true, :maincontent => maincontent.as_json, :references => maincontent.references.as_json}
    else
      render :json => {:status => "FAIL"}
    end


  end
  def maincontent
    (@content.parent == nil) ? @content : @content.parent
  end
  def upload
      #are we dealing with subcontent?
      if (params[:parent_id])
        logger.info "subcontent..."
        @content = Content.new
        @content.creator = User.find(current_user.id)
        @content.parent = Content.find(params[:parent_id])
        @content.update_attributes(params[:content])

        @content.save!
      else
        @content = Content.find(params[:id])
        @content.type = params[:content][:type]
        @content.update_attributes(params[:content])
      end

      @content.status = Content::STATUS_CONVERSION_IN_PROGRESS
      
      @content.value = File.new(async_upload params)

      @content.save

      render :json => {:success => true, :maincontent => maincontent.as_json}
  end
  def file_delete(filename)
    Dir["#{File.dirname(filename)}/*"].each do |file|
      next if File.basename(file) == File.basename(filename)
      FileUtils.rm_rf file, :noop => true, :verbose => true
    end
  end
  def async_upload params

      ajax_upload = params[:qqfile].is_a?(String)
      filename = ajax_upload  ? params[:qqfile] : params[:qqfile].original_filename
      extension = filename.split('.').last

      local_dir = "#{Rails.root}/files/#{@content.creator.id}/#{@content.id}/"
      local_file = local_dir+ "original.#{extension}"
      if File.exists? local_file
        file_delete local_dir
      end

      FileUtils.mkdir local_dir unless (File.directory? local_dir)

      File.open(local_file, 'wb') do |f|
        if ajax_upload
          f.write  request.body.read
        else
          f.write params[:qqfile].read
        end
      end

     local_file
  end

  # DELETE /contents/1
  def destroy
    @content = Content.find(params[:id])
    @content.destroy
    redirect_to "/users"
  end
end
