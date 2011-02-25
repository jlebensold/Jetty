class Video < Content
  ZC_KEY = '89db78eb49aaeecb61f4f877ff983051'
  def poster
    Content::S3_WEB.to_s + bucketpath + "/t/frame_0000.png"
  end
  def iphone
    Content::S3_WEB.to_s + bucketpath + "/iphone.mp4"
  end
  def webm
    Content::S3_WEB.to_s + bucketpath + "/desktop.webm"
  end
  def ogv
    Content::S3_WEB.to_s + bucketpath + "/desktop.ogv"
  end
  def ipad
    Content::S3_WEB.to_s + bucketpath + "/ipad.mp4"
  end

  def encode_video
      logger.info "is video... encoding"
      extension = local_value_file_name.split('.').last.to_s
      self.status = Content::STATUS_CONVERSION_IN_PROGRESS
      self.save!
      @bucket = Content::S3_BUCKET.to_s
      Zencoder.api_key = ZC_KEY
      Zencoder::Job.create({
                      :input => "s3://"+@bucket+"/uid/"+id.to_s+"."+extension,
                      :outputs => [{
                                    :label => 'vp8',
                                    :url => 's3://'+@bucket+'/uid/'+id.to_s+'.webm'
                                   },
                                   {
                                    :label => 'iphone',
                                    :url => 's3://'+@bucket+'/uid/'+id.to_s+'-iphone.mp4',
                                    :width => 480,
                                    :height => 320
                                   },
                                   {
                                    :label => 'ipad',
                                    :url => 's3://'+@bucket+'/uid/'+id.to_s+'-ipad.mp4',
                                    :width => 960,
                                    :height => 640
                                   },
                                   {
                                    :label => 'ogv',
                                    :url => 's3://'+@bucket+'/uid/'+id.to_s+'.ogv'
                                   },
                                   {
                                     :thumbnails =>
                                       { "number" => 1,
                                         "base_url" =>'s3://'+@bucket+'/uid/t'+id.to_s
                                       }
                                   }
                                 ]})
  end


end
