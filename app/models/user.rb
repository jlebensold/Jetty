class User < ActiveRecord::Base
  validates :email, :presence => true , :uniqueness => true
  validates :password, :presence => true
  validates :user_type, :presence => true
  has_one :user_type
end
