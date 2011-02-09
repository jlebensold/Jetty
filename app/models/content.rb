class Content < ActiveRecord::Base
  has_attached_file :value, 
    :storage => :s3,
    :s3_credentials => Rails.root.to_s + "/config/s3.yml" , 
    :bucket => 'jettytstcontent',
    :path => ":id_:title.:extension"

  belongs_to :creator , :class_name => "user"
  belongs_to :parent , :class_name => "content"

  Paperclip.interpolates :title do |attachment, style|
    attachment.instance.title
  end
end
