Rails.application.config.middleware.use OmniAuth::Builder do  
  require 'openid/store/filesystem'
  provider :twitter, 'eZhF6jzDCUEwpP8QuQ8inQ', 'lkqpmLUsdE0bPifitAXUbEgKK75SejQfwNl9Wvvj6g0'  
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'   
  # provider :google_apps, OpenID::Store::Filesystem.new('./tmp'), :name => 'google_apps'
  # /auth/google_apps; you can bypass the prompt for the domain with /auth/google_apps?domain=somedomain.com
   
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'yahoo', :identifier => 'yahoo.com' 

end  