require 'aws/s3'
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
  def src_url
    S3_WEB + poster
  end
  def check_status
    if (self.status == Content::STATUS_CONVERSION_IN_PROGRESS.to_s)
      AWS::S3::Base.establish_connection!(s3_keys)
      if(AWS::S3::S3Object.exists? bucketpath + "/iphone.mp4", Content::S3_BUCKET.to_s)
        self.status = STATUS_COMPLETE
        self.save!
      end
    end
  end
  def after_s3
      self.status = Content::STATUS_CONVERSION_IN_PROGRESS
      #Video.update(self.id , {:status => STATUS_CONVERSION_IN_PROGRESS})
      @bucket = Content::S3_BUCKET.to_s + "/" + bucketpath
      Zencoder.api_key = ZC_KEY
      Zencoder::Job.create({
                      :input => "s3://"+@bucket +"/original."+extension,
                      :outputs => [
                                   {
                                    :label => 'iphone',
                                    :url => 's3://'+@bucket + "/iphone.mp4",
                                    :width => 480,
                                    :height => 320,
                                    :public => 1
                                   },
                                   {
                                    :label => 'ipad',
                                    :url => 's3://'+@bucket + "/ipad.mp4",
                                    :width => 960,
                                    :height => 640,
                                    :public => 1
                                   },
                                   {
                                    :label => 'vp8',
                                    :url => 's3://'+@bucket + "/desktop.webm",
                                    :public => 1
                                   },
                                   {
                                    :label => 'ogv',
                                    :url => 's3://'+@bucket + "/desktop.ogv",
                                    :public => 1
                                   },
                                   {
                                     :thumbnails =>
                                       { :number => 1,
                                         :base_url =>'s3://'+@bucket+'/t',
                                          :public => 1
                                       }
                                   }
                                 ]})
  end


end
