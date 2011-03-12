class CourseItem < ActiveRecord::Base
  belongs_to :content,:foreign_key => "content_id"
  belongs_to :course ,:foreign_key => "course_id"
  validates :content, :presence => true
  validates :course, :presence => true
  validates :amount, :if => lambda { monetize }, :presence => true
  validates_inclusion_of :amount, :in => [0,nil], :if => lambda { !monetize }

  def as_json
    {
      :id => id,
      :monetize => monetize,
      :amount => amount,
      :course_id => course_id,
      :content_id =>  content_id,
      :course => course.as_json,
      :content => content.as_json
    }
  end
end
