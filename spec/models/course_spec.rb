require 'spec_helper'
describe Course do
  it { should have_many(:course_items) }
  it { should belong_to(:creator) }
end