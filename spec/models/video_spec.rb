# encoding: utf-8
describe Video do
  test_video = File.new(Rails.root.to_s + "/test/data/video-test.mov")
 
  it "has a creator" do
     v = Factory(:video)
     v.creator.should be_present
  end

  it "fires a delayed upload on file save" do
     v = Factory(:video)
     v.stub!(:queue_upload_to_s3).and_return {true }
     v.queue_upload_to_s3.should be_true
     v.update_attributes(:value =>test_video  );
  end
  it "has the correct path after file save" do
     v = Factory(:video)
     v.update_attributes(:value => test_video );
     v.save!
     v.value.to_file.path.should eq("files/#{v.creator.id}/#{v.id}/original.mov")
  end

  it "save a video in a proper temp folder" do
     v = Factory(:video)
     v.update_attributes(:value => test_video );
     v.save!
  end

  it "has a bucket path for each video type" do
    v = Factory(:video)
    v.bucketpath.should eq "files/#{v.creator.id}/#{v.id}"
  end

  it "has a poster path" do
    assert Factory(:video).poster.include? 't/frame_0000.png'
  end
  it "has iphone path" do
    assert Factory(:video).iphone.include? 'iphone.mp4'
  end
  it "has ipad path" do
     assert Factory(:video).ipad.include? 'ipad.mp4'
  end
  it "has ogv path" do
     assert Factory(:video).ogv.include? 'desktop.ogv'
  end
  it "has webm path" do
     assert Factory(:video).webm.include? 'desktop.webm'
  end

  it "becomes status in progress when zencoder is called" do
    v = Factory(:video)
    #mock zencoder:
    module Zencoder
      class Job
        def self.create(params={}, options={})
        end
      end
    end
    v.update_attributes(:value => test_video );
    v.save!
    v.after_s3
    v.status.should eq(Content::STATUS_CONVERSION_IN_PROGRESS)
  end


end