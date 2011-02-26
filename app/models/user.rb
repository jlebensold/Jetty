class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  include ActiveModel::Validations
  has_many :contents, :class_name => "Content", :foreign_key => "creator_id"
  validates :email, :presence => true , :uniqueness => true, :email => true
  validates :password, :presence => true
  validates :type, :presence => true

  def self.attributes_protected_by_default
  end
  
  after_initialize :default_values
  def default_values
    self.type = "Publisher"
  end

end
