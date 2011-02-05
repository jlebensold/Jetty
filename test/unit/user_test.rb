require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "uniqueness" do
    u1 = User.create :email => "a@a.com" , :password => "abc123", :user_type => UserType.first
    assert u1.valid?

    u2 = User.create :email => "a@a.com" , :password => "1234", :user_type => UserType.first
    assert !u2.valid?
  end

  test "email, userType and password required" do
    u1 = User.create :email => "a@a.com" , :password => "abc123", :user_type => UserType.first
    assert u1.valid?, "required field missing"
  end

  
  
end