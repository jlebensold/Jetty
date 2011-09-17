class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
#  devise :database_authenticatable, :registerable,
#         :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :registerable, :recoverable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:paypal_email

  include ActiveModel::Validations
  has_many :contents, :class_name => "Content", :foreign_key => "creator_id"
  has_many :courses, :class_name => "Course", :foreign_key => "creator_id"
  has_many :purchases, :class_name => "Payment", :foreign_key => "user_id"
  validates :email, :presence => true , :uniqueness => true, :email => true
  validates :password, :presence => true
  validates :type, :presence => true

  def self.attributes_protected_by_default
  end
  def files_folder
    "files/#{id}"
  end
  def playable? course_item
    if current_user.purchased?(course_item.content) 
      return true 
    end

    if (self.id == course_item.content.creator_id)
      return true
    end
    false
  end
  def purchased? content
    purchases.each { |p| return true if (p.purchaseable_id == content.id  || content.creator_id.eql?(self.id)) }
    false
  end

  def checkfolder
    unless File.exists? files_folder
      FileUtils.mkdir_p files_folder
    end
  end
  def maincontents
    contents.find_all {|c| c.parent == nil}
  end
  after_initialize :default_values
  def default_values
    self.type = "Publisher"
  end

end
