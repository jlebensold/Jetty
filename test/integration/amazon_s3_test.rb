require 'test_helper'
require 'aws/s3'

# require 'zenconder'

class AmazonS3Test < ActionController::IntegrationTest
  bucket = "jettytstcontent"
  test "shouldWriteToS3" do
  

    AWS::S3::Base.establish_connection!(
        :access_key_id     => 'AKIAILUQ4OZEBWEEK3OA',
        :secret_access_key => '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'
      )
    file = "./test/data/image-test.jpg"
    store file , bucket
    #file = "./test/data/video-test.mov"
    #store file

    puts AWS::S3::S3Object.url_for(File.basename(file), bucket)
=begin


    fileOnS3 = "http://s3.amazonaws.com/jettytstcontent/video-test.mov?AWSAccessKeyId=AKIAILUQ4OZEBWEEK3OA&Expires=1297019271&Signature=7siNGdb6TlMw3R1hQn7ur%2BXU8kg%3D"

    Zencoder.api_key = '89db78eb49aaeecb61f4f877ff983051'
    Zencoder::Job.create({
                      :input => "s3://"+bucket+"/video-test.mov",
                      :outputs => [{
                                    :label => 'vp8',
                                    :url => 's3://'+bucket+'/video-test_output.webm'
                                   },
                                   {
                                    :label => 'mp4',
                                    :url => 's3://'+bucket+'/video-test_output.mp4'
                                   },
                                   {
                                     :thumbnails =>
                                       { "number" => 10,
                                         "base_url" =>'s3://'+bucket+'/thumbs'
                                       }
                                   }
                                  ]})
=end

  end



  def store file, bucket
    AWS::S3::S3Object.store(File.basename(file),
                        open(file),
                        bucket,
                        :access => :public_read)

  end

end
