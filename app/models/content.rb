require 'mime/types'
class Content < ActiveRecord::Base

  belongs_to :creator , :class_name => "User" , :foreign_key => "creator_id"
  belongs_to :parent , :class_name => "Content", :foreign_key => "parent_id"
  has_many  :children, :class_name => "Content", :foreign_key => "parent_id",  :dependent => :delete_all
  has_many  :course_items,  :foreign_key => "content_id",  :dependent => :delete_all
  validates :creator, :presence => true

  has_many :purchases, :as => :purchaseable


#  validates :publish, :date_or_blank => true
#  validates :expire, :date_or_blank => true


  STATUS_OFFLINE = "offline"
  STATUS_FAILURE = "failure"
  STATUS_COMPLETE = "complete"
  STATUS_CONVERSION_IN_PROGRESS = "conversion in progress"
  STATUS_UPLOAD_IN_PROGRESS = "upload in progress"
  S3_PATH   = Rails.root.to_s + "/config/s3.yml"
  S3_BUCKET = "jettytstcontent"
  S3_WEB    = "https://s3.amazonaws.com/jettytstcontent/"

  def do_upload val
    @do_upload = val
  end

  def self.attributes_protected_by_default
  end
  def original_file
    S3_WEB + bucketpath + "/original.#{extension}"
  end
  def src_url
    original_file
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
  c.status = Content::STATUS_CONVERSION_IN_PROGRESS
  c.save!
  end

  alias_method :value=, :local_value=
  def value
    self.remote_value? ? self.remote_value : self.local_value
  end
  
  after_initialize :default_values
  def default_values
    @do_upload = false;
    self.status ||= STATUS_OFFLINE.to_s
    if self.status == STATUS_CONVERSION_IN_PROGRESS
      check_status
    end
  end
  def check_status
      self.status = STATUS_OFFLINE
      self.save!
  end
  def load_keys path
    creds = YAML::load(ERB.new(File.read(path)).result).stringify_keys
    (creds[Rails.env] || creds).symbolize_keys
  end
  def s3_keys
    load_keys(Content::S3_PATH)
  end
  after_save :aftersave
  def aftersave
    before_s3
    if (@do_upload)
      do_upload false
      logger.info ">>>>queue delayed job?"
      delay.upload_to_s3 self.id
    else
      logger.info "<<<< skipping upload"
    end
  end
  def after_s3
  end
  def before_s3
  end
  def upload_to_s3 id
    @content = Content.find(id)
#    logger.info "uploading to S3! " + self.type
    @content.remote_value = @content.local_value.to_file
    @content.save!
    after_s3
  end


  def bucketpath
    "files/#{creator.id}/#{id}"
  end
  def extension
    return "" if (local_value_file_name == nil)
    local_value_file_name.split('.').last.to_s
  end
  def subcontents
    children.find_all{|item| !item.instance_of? Url }
  end
  def references
    children.find_all{|item| item.instance_of? Url }
  end
  def as_json(options = {})
    if (options == nil)
      options = {}
    end
    options.merge({
      :id => id,
      :title => title,
      :tagline => tagline,
      :status => status,
      :type => type,
      :meta => meta,
      :src => src_url
    })
  end

end
