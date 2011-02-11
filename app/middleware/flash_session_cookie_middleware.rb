#### for app/middleware/flash_session_cookie_middleware.rb (I KNOW it doesn't exist... make it!)
#
# http://thewebfellas.com/blog/2008/12/22 … the-rescue
#

require 'rack/utils'

class FlashSessionCookieMiddleware
  def initialize(app, session_key = '_session_id')
    @app = app
    @session_key = session_key
  end

  def call(env)
    if env['HTTP_USER_AGENT'] =~ /^(Adobe|Shockwave) Flash/
      req = Rack::Request.new(env)
      env['HTTP_COOKIE'] = [ @session_key, req.params[@session_key] ].join('=').freeze unless req.params[@session_key].nil?
      env['HTTP_ACCEPT'] = "#{req.params['_http_accept']}".freeze unless req.params['_http_accept'].nil?
    end
    @app.call(env)
  end
end