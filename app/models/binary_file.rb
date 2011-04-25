class BinaryFile < Content

  def check_status
    if (self.status == Content::STATUS_CONVERSION_IN_PROGRESS.to_s)
      AWS::S3::Base.establish_connection!(s3_keys)
      if(AWS::S3::S3Object.exists? bucketpath + "/original.#{extension}", Content::S3_BUCKET.to_s)
        self.status = STATUS_COMPLETE
        self.save!
      end
    end
  end
  def icon
    #return extension
    case extension.downcase
    when "zip","rar","tar.gz""tar","gz"
      return "package.png"
    else
      return "page_white.png"
    end
  end
end
