describe Publisher do
  it "has an email address" do
    v = Factory(:video)
    v.creator.email.should be_present
  end

end
