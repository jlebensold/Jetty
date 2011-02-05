class User < ActiveRecord::Base
  validates :email, :presence => true , :uniqueness => true
  validates :password, :presence => true
  validates :user_type, :presence => true
  belongs_to :user_type
end
