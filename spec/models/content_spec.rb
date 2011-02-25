require 'spec_helper'
require 'PP'
describe Content do

  it "can have a valid video" do
   v = Factory(:video)
   v.should be_present
   v.type.should eql "Video"
   v.creator.should be_present
  end

  it "can have children content" do
   v = Factory(:video)
   v.children = [Factory(:image),Factory(:image)]
   v.save!
   
   v.children.count.should eql 2
  end

  it "children can have parents" do
   v = Factory(:video)
   v.parent = Factory(:image)
   v.save!
   v.parent.should be_kind_of Image
   assert v.parent.title.include? 'title'
  end
  it "has a creator" do
    v = Factory(:video)
    v.creator.should be_kind_of User
  end


end
