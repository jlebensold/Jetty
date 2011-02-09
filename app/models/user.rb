class User < ActiveRecord::Base
  validates :email, :presence => true , :uniqueness => true
  validates :password, :presence => true
  validates :type, :presence => true
end
