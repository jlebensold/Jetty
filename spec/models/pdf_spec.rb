# encoding: utf-8
describe Pdf do

  def stub
    AWS::S3::Base.stub!(:establish_connection!).and_return(true)
  end


  it "bucketpath" do
    assert Factory(:pdf).swf_path.include? 'pdf.swf'
  end

  it "has status" do
    pdf = Factory(:pdf)
    stub
    AWS::S3::S3Object.stub!(:exists?).and_return(true)
    assert pdf.status.should eql Content::STATUS_OFFLINE
    pdf.status = Content::STATUS_CONVERSION_IN_PROGRESS
    pdf.check_status
    assert pdf.status.should eql Content::STATUS_COMPLETE
  end

  it "runs paperclip command before s3 upload " do
    pdf = Factory(:pdf)
    Paperclip.stub!(:run).and_return(true)
    FileUtils.touch pdf.swf_path
    FileUtils.touch pdf.bucketpath + "/original.pdf"
    assert pdf.before_s3
    FileUtils.rm pdf.swf_path
    FileUtils.rm pdf.bucketpath + "/original.pdf"
  end
  

  it "has status_complete after save" do
    stub
    pdf = Factory(:pdf)
    FileUtils.touch pdf.swf_path
    AWS::S3::S3Object.stub!(:store).and_return(true)
    
    assert pdf.status.should eql Content::STATUS_OFFLINE
    pdf.after_s3
    assert pdf.status.should eql Content::STATUS_COMPLETE
    FileUtils.rm pdf.swf_path
  end


end
