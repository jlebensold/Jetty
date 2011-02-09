class HomeController  < ApplicationController
  def index
    logger.debug params
    if params[:name]
        encode_file(:url => params[:name], :bucket =>"jettytstcontent")
    end
  end
  def encode_file params
    bucket = params[:bucket]
    url = params[:url]
    Zencoder.api_key = '89db78eb49aaeecb61f4f877ff983051'
    Zencoder::Job.create({
                      :input => "s3://#{bucket}/#{url}.orig",
                      :outputs => [{
                                    :label => 'vp8',
                                    :url => "s3://#{bucket}/#{url}.webm"
                                   },
                                   {
                                    :label => 'mp4',
                                    :url => "s3://#{bucket}/#{url}.mp4"
                                   },
                                   {
                                     :thumbnails =>
                                       { "number" => 1,
                                         "base_url" =>"s3://#{bucket}/#{url}-thumbs"
                                       }
                                   }
                                  ]})
    
  end
end
