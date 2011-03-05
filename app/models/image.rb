require 'aws/s3'
class Image < Content

  def check_status
    if (self.status == Content::STATUS_CONVERSION_IN_PROGRESS.to_s)
      AWS::S3::Base.establish_connection!(s3_keys)
      if(AWS::S3::S3Object.exists? small, Content::S3_BUCKET.to_s)
        self.status = STATUS_COMPLETE
        self.save!
      end
    end
  end
  def src_url
    S3_WEB + thumb
  end
  def large
    bucketpath + "/l." + extension
  end
  def small
    bucketpath + "/s." + extension
  end
  def thumb
    bucketpath + "/t." + extension
  end

  def before_s3
    directory = Rails.root.to_s
    original_path = File.join(directory, bucketpath, "original." + extension)

    return unless ( File.exist?(original_path))

    File.open(File.join(directory, thumb),"wb") do |f|
      f<< Paperclip::Thumbnail.new(File.open(original_path,"rb"),{:geometry => "100x60#"}).make.read
    end
    
    File.open(File.join(directory, small),"wb") do |f|
      f<< Paperclip::Thumbnail.new(File.open(original_path,"rb"),{:geometry => "210x320#"}).make.read
    end

    File.open(File.join(directory, large ),"wb") do |f|
      f<< Paperclip::Thumbnail.new(File.open(original_path,"rb"),{:geometry => "400x600"}).make.read
    end
  end
  def after_s3
      AWS::S3::Base.establish_connection!(s3_keys)
      
      AWS::S3::S3Object.store(large,open(large),S3_BUCKET)
      AWS::S3::S3Object.store(small,open(small),S3_BUCKET)
      AWS::S3::S3Object.store(thumb,open(thumb),S3_BUCKET)
      
      self.status = Content::STATUS_COMPLETE;
      self.save!
  end
end