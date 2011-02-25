class User < ActiveRecord::Base
  has_many :contents, :class_name => "Content", :foreign_key => "creator_id"
  validates :email, :presence => true , :uniqueness => true
  validates :password, :presence => true
  validates :type, :presence => true
end
