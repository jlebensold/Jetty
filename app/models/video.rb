require 'aws/s3'
class Video < Content
  ZC_PATH   = Rails.root.to_s + "/config/zencoder.yml"
  def initialize
    
  end

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
    poster
  end
  def check_status
#    if (self.status == Content::STATUS_CONVERSION_IN_PROGRESS.to_s)
#      AWS::S3::Base.establish_connection!(s3_keys)
#      if(AWS::S3::S3Object.exists? bucketpath + "/iphone.mp4", Content::S3_BUCKET.to_s)
#        self.status = STATUS_COMPLETE
#        self.save!
#      end
#    end
  end  
  def after_s3
      logger.info "~>>>>video: after s3"
      #really? self?
      self.status = Content::STATUS_CONVERSION_IN_PROGRESS
      #Video.update(self.id , {:status => STATUS_CONVERSION_IN_PROGRESS})
      @bucket = Content::S3_BUCKET.to_s + "/" + bucketpath
      Zencoder::Job.create({
                      :input => "s3://"+@bucket +"/original."+extension,
                      :api_key => load_keys(ZC_PATH)[:key],
                      :outputs => [
                                   {
                                    :label => 'iphone',
                                    :url => 's3://'+@bucket + "/iphone.mp4",
                                    :width => 480,
                                    :height => 320,
                                    :public => 1,
                                    :thumbnails =>
                                       { :number => 1,
                                         :base_url =>'s3://'+@bucket+'/t',
                                         :public => 1
                                       },
                                    :notifications => [
                                      {
                                        :url => load_keys(ZC_PATH)[:notification_url] + "zencoder/#{id}/iphone",
                                        :format => "json"
                                      }
                                    ]
                                   },
                                   {
                                    :label => 'ipad',
                                    :url => 's3://'+@bucket + "/ipad.mp4",
                                    :width => 960,
                                    :height => 640,
                                    :public => 1,
                                    :notifications => [
                                      {
                                        :url => load_keys(ZC_PATH)[:notification_url] + "zencoder/#{id}/ipad",
                                        :format => "json"
                                      }
                                    ]
                                   },
                                   {
                                    :label => 'ogv',
                                    :url => 's3://'+@bucket + "/desktop.ogv",
                                    :public => 1,
                                    :notifications => [
                                      {
                                        :url =>  load_keys(ZC_PATH)[:notification_url] + "zencoder/#{id}/ogv",
                                        :format => "json"
                                      }
                                      
                                    ]
                                   }

                                 ]})
  end
  def as_json(options = {})
    if (!options)
      options = {}
    end
    options[:visible] = true
    options[:ipad] = ipad
    options[:iphone] = iphone
    options[:ogv] = ogv
    super.as_json()
  end
  def as_jsonpreview(purchased_or_free)
    if (purchased_or_free)
      opts = self.as_json()
    else
      opts = self.as_json()
      opts[:visible] = true
      opts[:ipad] = ''
      opts[:iphone] = ''
      opts[:ogv] = ''
    
    end
    opts[:visible] = purchased_or_free
    opts
  end


end
