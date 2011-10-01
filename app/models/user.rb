class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
#  devise :database_authenticatable, :registerable,
#         :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :registerable, :recoverable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:paypal_email

  include ActiveModel::Validations
  has_many :services, :dependent => :destroy

  has_many :contents, :class_name => "Content", :foreign_key => "creator_id"
  has_many :courses, :class_name => "Course", :foreign_key => "creator_id"
  has_many :purchases, :class_name => "Payment", :foreign_key => "user_id"
  #validates :email, :presence => true , :uniqueness => true, :email => true
  #validates :password, :presence => true
  validates :type, :presence => true

  def self.attributes_protected_by_default
  end
  def files_folder
    "files/#{id}"
  end
  def playable? course_item
    return true if self.purchased?(course_item)
    return true if self.id == course_item.content.creator_id
    return true if self.purchased?(course_item.course)
    false
  end
  def purchased? course_item
    if(course_item.kind_of? Course)
      purchases.each { |p| return true if (p.purchaseable_id == course_item.id && p.purchaseable_type == "Course"  || course_item.creator_id.eql?(self.id)) }    
    else
      purchases.each { |p| return true if (p.purchaseable_id == course_item.id && p.purchaseable_type == "CourseItem" || course_item.content.creator_id.eql?(self.id)) }    
    end
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
