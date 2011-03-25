class Pdf < Content
  def swf_path
    bucketpath + "/pdf.swf"
  end
  def before_s3
    directory = Rails.root.to_s
    original_path = File.join(directory, self.bucketpath, "original.pdf")
    return unless(File.exist?(original_path))

    parameters = []
    parameters << ":source"
    parameters << ":dest"
    parameters << " -T 9 -f"

    Paperclip.run("pdf2swf", parameters.flatten.compact.join(" ").strip.squeeze(" "), :source => "#{File.expand_path(original_path)}",:dest => File.expand_path(File.join(directory,swf_path)))
  end
  def check_status
    if (self.status == Content::STATUS_CONVERSION_IN_PROGRESS.to_s)
      AWS::S3::Base.establish_connection!(s3_keys)
      if(AWS::S3::S3Object.exists? swf_path, Content::S3_BUCKET.to_s)
        self.status = STATUS_COMPLETE
        self.save!
      end
    end
  end
  def after_s3
      AWS::S3::Base.establish_connection!(s3_keys)
      logger.info "PDF: after s3 : " + swf_path
      AWS::S3::S3Object.store(swf_path,open(swf_path),S3_BUCKET)
      self.status = Content::STATUS_COMPLETE;
      self.save!
  end
  
end
