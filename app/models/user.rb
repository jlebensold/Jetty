class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  include ActiveModel::Validations
  has_many :contents, :class_name => "Content", :foreign_key => "creator_id"
  has_many :courses, :class_name => "Course", :foreign_key => "creator_id"
  validates :email, :presence => true , :uniqueness => true, :email => true
  validates :password, :presence => true
  validates :type, :presence => true

  def self.attributes_protected_by_default
  end
  def files_folder
    "files/#{id}"
  end
  def purchased? content
    found_payment = Payment.find_all_by_email(email).find_all { |p| p.purchaseable_type == "Content" && p.purchaseable_id == content.id  }
    (found_payment.length > 0)
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
