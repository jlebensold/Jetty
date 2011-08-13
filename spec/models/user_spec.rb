require 'spec_helper'
describe User do
  it "should always have a home folder after checkfolder is run" do
    @user = Factory(:publisher)
    @user.save!
    FileUtils.rm_rf @user.files_folder
    assert !File.exist?(@user.files_folder)
    @user.checkfolder
    assert File.exist?(@user.files_folder)
  end
  it "should create users that are User by default" do
    @user = User.new
    @user.password = "foo@asd.com"
    @user.email = "foo@asd.com"
    @user.save!

    assert @user.type.should eq("User")


  end


end
