class CourseItem < ActiveRecord::Base
  belongs_to :content,:foreign_key => "content_id"
  belongs_to :course ,:foreign_key => "course_id"
  validates :content, :presence => true
  validates :course, :presence => true
  validates :amount, :if => lambda { monetize }, :presence => true
  validates_inclusion_of :amount, :in => [0,nil], :if => lambda { !monetize }
  def is_free?
    return true if ordering == 0
    return monetize == false
  end
  def as_json
    {
      :id => id,
      :monetize => monetize,
      :monetize_return_url => monetize_return_url,
      :amount => amount,
      :ordering => ordering,
      :course_id => course_id,
      :content_id =>  content_id,
      :course => course.as_json,
      :content => content.as_json
    }
  end
end
