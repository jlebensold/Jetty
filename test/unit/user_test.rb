require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "uniqueness" do
    u1 = Patron.create :email => "a@a.com" , :password => "abc123"
    assert u1.valid?

    u2 = Patron.create :email => "a@a.com" , :password => "1234"
    assert !u2.valid?
  end

  test "email and password required" do
    u1 = Publisher.create :email => "a@a.com" , :password => "abc123"
    assert u1.valid?, "required field missing"
  end

  test "admin inherits from user" do
    u1 = Administrator.create :email => "a@a.com", :password => "d"
    assert Administrator.find(:all).count == 1

  end
  
end