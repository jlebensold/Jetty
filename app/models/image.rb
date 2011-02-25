require 'PP'
class Image < Content
  def large
    bucketpath + "/l." + extension
  end
  def small
    bucketpath + "/s." + extension
  end

  def before_s3
    directory = Rails.root.to_s
    original_path = File.join(directory, bucketpath, "original." + extension)
    File.open(File.join(directory, small),"wb") do |f|
      f<< Paperclip::Thumbnail.new(File.open(original_path,"rb"),{:geometry => "210x320"}).make.read
    end

    File.open(File.join(directory, large ),"wb") do |f|
      f<< Paperclip::Thumbnail.new(File.open(original_path,"rb"),{:geometry => "400x600"}).make.read
    end
  end
  def after_s3
      AWS::S3::Base.establish_connection!(s3_keys)
      
      AWS::S3::S3Object.store(large,open(large),S3_BUCKET)
      AWS::S3::S3Object.store(small,open(small),S3_BUCKET)
  end
end