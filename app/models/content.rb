require 'mime/types'
class Content < ActiveRecord::Base

  belongs_to :creator , :class_name => "User" , :foreign_key => :creator_id
  belongs_to :parent , :class_name => "Content", :foreign_key => :parent_id
  has_many :children, :class_name => "Content" , :foreign_key => :parent_id


  STATUS_OFFLINE = "offline"
  STATUS_FAILURE = "failure"
  STATUS_COMPLETE = "complete"
  STATUS_CONVERSION_IN_PROGRESS = "conversion in progress"
  STATUS_UPLOAD_IN_PROGRESS = "upload in progress"
  S3_PATH =Rails.root.to_s + "/config/s3.yml"
  S3_BUCKET = "jettytstcontent"
  S3_WEB = "https://s3.amazonaws.com/jettytstcontent/"
  

  def self.attributes_protected_by_default
  end


  has_attached_file :local_value,
    :path => "files/:creatorid/:id/original.:extension"



  has_attached_file :remote_value,
    :storage => :s3,
    :s3_credentials => S3_PATH ,
    :bucket => S3_BUCKET,
    :path => "files/:creatorid/:id/original.:extension"

  Paperclip.interpolates :creatorid do |attachment, style|
    attachment.instance.creator_id.to_s
  end

  before_post_process :preprocess
  def preprocess
  c = Content.find(id)
  c.status = Content::STATUS_UPLOAD_IN_PROGRESS.to_s
  c.save!
  end

  alias_method :value=, :local_value=
  def value
    self.remote_value? ? self.remote_value : self.local_value
  end
  
  after_initialize :default_values
  def default_values
    self.status ||= STATUS_OFFLINE.to_s
    self.check_status
  end
  def check_status
        self.status = STATUS_COMPLETE
        self.save!
  end
  def s3_keys
    creds = YAML::load(ERB.new(File.read(Content::S3_PATH)).result).stringify_keys
    (creds[Rails.env] || creds).symbolize_keys
  end

  after_save :after_save
  def after_save
    before_s3
    logger.info "queue delayed job?"
    delay.upload_to_s3 if self.local_value_updated_at_changed?
  end
  def after_s3
  end
  def before_s3
  end
  def upload_to_s3
    logger.info "uploading to S3! " + self.type
    self.remote_value = local_value.to_file
    self.save!
    after_s3
  end


  def bucketpath
    "files/#{creator.id}/#{id}"
  end
  def extension
    local_value_file_name.split('.').last.to_s
  end


end
