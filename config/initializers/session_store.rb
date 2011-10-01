# Be sure to restart your server when you modify this file.

#Jetty::Application.config.session_store :cookie_store, :key => '_jetty_session'
#Jetty::Application.config.session_store :active_record_store

Jetty::Application.config.session_store :cookie_store

Jetty::Application.config.session = {
  :key          => '_getjetty_session',     # name of cookie that stores the data
  :domain       => nil,                         # you can share between subdomains here: '.communityguides.eu'
  :expire_after => 1.month,                     # expire cookie
  :secure       => false,                       # fore https if true
  :httponly     => true,                        # a measure against XSS attacks, prevent client side scripts from accessing the cookie
  :secret      => '6b18fef2b8be129bdbcfba03ef3f4f95588eadb5a0d873292a65438b0bd29051db0ad74f88904a8592c986c8af2e76ee793e8de5e1fdea242f5d1ea9d2285410'
}