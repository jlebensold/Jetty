require 'PP'
require 'test_helper'

class ContentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert false , "sadasd"
  end

  test "can parse video filenames for remote persistence" do
    @content = Content.new(:type => "Video" , :title => "myTitle", :local_value =>File.new(Rails.root.to_s + "/test/data/video-test.mov")  );

    #puts pp(@content.local_value.queued_for_write[:original].path.split('.').first) #


  end
end
