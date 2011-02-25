require 'PP'
require 'test_helper'
def override_method(obj, method_name, &block)
  # Get the singleton class/eigenclass for 'obj'
  klass = class <<obj; self; end

  # Undefine the old method (using 'send' since 'undef_method' is protected)
  klass.send(:undef_method, method_name)

  # Create the new method
  klass.send(:define_method, method_name, block)
end


class ContentTest < ActiveSupport::TestCase
  @@called = false
  def called
    @@called = true
  end
  def is_called
    @@called
  end
  
  # Replace this with your real tests.
  test "the truth" do
    assert true, "sadasd"
  end

  test "file save queues file for upload" do
    @content = Content.new(:title => "test")
    

    
    @content.save!
    @content.update_attributes(:type => "Video" , :title => "myTitle", :value =>File.new(Rails.root.to_s + "/test/data/video-test.mov")  );
    #assert is_called, "queue_upload_to_s3 not called"

  end


  test "can parse video filenames for remote persistence" do
    @content = Content.new(:title => "test")

    @content.save!
    @content.update_attributes(:type => "Video" , :title => "myTitle", :value =>File.new(Rails.root.to_s + "/test/data/video-test.mov")  );
    #puts @content.id
    #@content.save!
    pp @content

  end
end
