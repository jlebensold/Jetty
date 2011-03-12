require 'spec_helper'
describe CourseItem do
  it { should belong_to(:content) }
  it { should belong_to(:course) }

  it "should have an amount if monetizable" do
     c = CourseItem.new
     c.content = Factory(:pdf)
     c.course = Factory(:course)
     c.valid?.should be_true
     c.monetize = true
     c.valid?.should be_false
     c.amount = 1.99
     c.valid?.should be_true
  end

  it "should not have amount if not monetizable" do
     c = CourseItem.new
     c.content = Factory(:pdf)
     c.course = Factory(:course)
     c.amount = 1.99
     c.valid?.should be_false
     c.monetize = true
     c.valid?.should be_true
     c.monetize = false
     c.amount = nil
     c.valid?.should be_true
  end
  

  it "has parameters as json" do
    c = CourseItem.new
    c.content = Factory(:pdf)
    c.course = Factory(:course)
    c.as_json.to_s.include? "monetize : false"
    c.as_json.to_s.include? "amount : null"
    c.as_json.to_s.include? "course_id : #{c.course_id}"
    c.as_json.to_s.include? "content_id : #{c.content_id}"
    
  end
  
end
