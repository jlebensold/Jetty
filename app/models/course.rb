class Course < ActiveRecord::Base
  belongs_to :creator , :class_name => "User" , :foreign_key => :creator_id

  has_many  :course_items, :foreign_key => "course_id",  :dependent => :delete_all

  def as_json(options = {})
    {
      :id => id,
      :title => title,
      :description => description
    }
  end

end
