require 'PP'
require 'mime/types'

class Content < ActiveRecord::Base
  @bucket = 'jettytstcontent'
  
  has_attached_file :local_value

  has_attached_file :remote_value,
    :storage => :s3,
    :s3_credentials => Rails.root.to_s + "/config/s3.yml" ,
    :bucket => @bucket,
    :path => ":id_:title.:extension"
  
  belongs_to :creator , :class_name => "user"
  belongs_to :parent , :class_name => "content"

  after_save :queue_upload_to_s3

  def queue_upload_to_s3
    logger.info ">>>>>queueing!"
    logger.info pp(local_value.to_file)
    logger.info "<<<<<<<<<<<<<<"
    send_later(:upload_to_s3) if self.local_value_updated_at_changed?
  end

  def upload_to_s3
    logger.info "uploading to S3!"
    self.remote_value = local_value.to_file
    self.save!
    if (self.type == "Video")
      puts pp(@content.remote_value)
      Zencoder.api_key = '89db78eb49aaeecb61f4f877ff983051'
      Zencoder::Job.create({
                      :input => "s3://"+bucket+"/"+id+".mov",
                      :outputs => [{
                                    :label => 'vp8',
                                    :url => 's3://'+@bucket+'/'+id+'.webm'
                                   },
                                   {
                                    :label => 'mp4',
                                    :url => 's3://'+@bucket+'/'+id+'.mp4'
                                   },
                                   {
                                     :thumbnails =>
                                       { "number" => 10,
                                         "base_url" =>'s3://'+@bucket+'/t-'+self.id
                                       }
                                   }
                                  ]})
    end
  end
  alias_method :value=, :local_value=
  def value
    self.remote_value? ? self.remote_value : self.local_value
  end


  # Fix the mime types. Make sure to require the mime-types gem
  Paperclip.interpolates :title do |attachment, style|
    attachment.instance.title
  end



end
