class Service < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid, :uname, :uemail, :user_id, :publisher_origin_id
  
end
