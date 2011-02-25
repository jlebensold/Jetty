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
    v.bucketpath.should eq "files/#{v.creator.id}/#{v.id}/"
  end

end