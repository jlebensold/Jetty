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

  def convert_date str
    begin
      str.to_s.to_date
    rescue ArgumentError
      ""
    end
  end
  def save
    @content = Content.find(params[:id])

    params[:content][:publish] = convert_date params[:content][:publish]
    params[:content][:expire] = convert_date params[:content][:expire]
    
    if @content.update_attributes(params[:content])
      if (params[:subcontent])
        unless (params[:subcontent].is_a? String)
          sub_ids = params[:subcontent].collect {|k,item| item[:id].to_i}
          ref_ids = @content.children.collect { |i| i.id.to_i }

          #filter out the missing references in the submission:
          ref_ids.keep_if {|rid| sub_ids.select{|sid| sid == rid}.count == 0 }
          ref_ids.each { |filter_id|
            @content.children.find(filter_id).delete
          }
          params[:subcontent].each { |key,item|
            content = Content.find_or_initialize_by_id(item[:id])
            content.creator = @content.creator
            content.update_attributes(item)
            content.parent = @content
            content.save
          }
        else
          @content.children.each do |r|
            r.delete
          end
        end
          #refresh
          @content.children true
      end
      render :json => {:success => true, :maincontent => maincontent.as_json, :references => maincontent.references.as_json, :subcontents => maincontent.subcontents.as_json }
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
        @content = Content.new
        @content.creator = User.find(current_user.id)
        @content.parent = Content.find(params[:parent_id])
      else
        @content = Content.find(params[:id])
        @content.value = nil
        @content.type = params[:content][:type]
      end
      @content.update_attributes(params[:content])
      @content.save!
      #@content = Content.find(params[:id])
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
