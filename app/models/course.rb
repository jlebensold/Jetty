class Course < ActiveRecord::Base
  belongs_to :creator , :class_name => "User" , :foreign_key => :creator_id

  has_many  :course_items, :foreign_key => "course_id",  :dependent => :delete_all , :order => "ordering"
  has_many :purchases, :as => :purchaseable

  def as_jsonpreview(user)
    
    opts = as_json
    opts[:purchased] = user != nil && user.purchased?(self)
    opts
  end
  
  def as_json(options = {})
    {
      :id => id,
      :title => title,
      :description => description,
      :amount => amount,
      :monetize => monetize,
      :monetize_return_url => monetize_return_url,      
      :default_return_url => default_return_url,
      :default_amount => default_amount
    }
  end

end
