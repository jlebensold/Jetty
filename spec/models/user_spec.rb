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
  

end
