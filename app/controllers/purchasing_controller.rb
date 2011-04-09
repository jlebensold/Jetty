class PurchasingController < ApplicationController
  def index
    
  end
  
  def checkout
    @myip = "93.172.40.45"
    @content = Content.last

#    session[:purchased] = nil
    pay_request = PaypalAdaptive::Request.new
    data = {
    "returnUrl" => url_for(:action => 'index', :only_path => false),
    "requestEnvelope" => {"errorLanguage" => "en_US"},
    "currencyCode"=>"USD",
    "receiverList"=>
        {"receiver"=>[{"email"=>"Merch1_1301751699_biz@lebensold.ca", "amount"=>"10.00", "primary" => true},
        {"email"=>"jon_1301144760_biz@lebensold.ca", "amount"=>"2.50", "primary" => false}]
    },
    "cancelUrl"=>url_for(:action => 'index', :only_path => false),
    "trackingId" => current_user.id.to_s+"|c|"+@content.id.to_s,
    "actionType"=>"PAY",
    "ipnNotificationUrl"=>"http://#{@myip}:3000/purchasing/ipn"
    }
    logger.info "SENDING CUSTOMER ID: " + data["custom"].to_s
    pay_response = pay_request.pay(data)
    if pay_response.success?
       redirect_to pay_response.approve_paypal_payment_url
    else
      puts pay_response.errors.first['message']
    end
  end
  def confirm
    
  end
  skip_before_filter :verify_authenticity_token
  def ipn

    #validate:
    paypal_response = IpnValidator.new(params, request.raw_post)
    require 'PP'
    logger.info "validation..."
    logger.info pp(paypal_response.valid?)

    logger.info "tracker: " + params["tracking_id"].to_s
    p_split = params["tracking_id"].split('|')
    @user = User.find(p_split.first.to_i)
    @content = Content.find(p_split.last.to_i)
    payment = Payment.new
    payment.email = @user.email
    payment.purchaseable = @content
    payment.save!
  end

end
class IpnValidator

  def initialize(params, raw_post)
    @params = params
    @raw = raw_post
  end

  def valid?
    uri = URI.parse(PaypalAdaptive::Config.new.paypal_base_url + '/webscr?cmd=_notify-validate')

    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 60
    http.read_timeout = 60
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    response = http.post(uri.request_uri, @raw,
                         'Content-Length' => "#{@raw.size}",
                         'User-Agent' => "My custom user agent"
                       ).body

    raise StandardError.new("Faulty paypal result: #{response}") unless ["VERIFIED", "INVALID"].include?(response)
    raise StandardError.new("Invalid IPN: #{response}") unless response == "VERIFIED"

    true
  end

  def completed?
    status == "COMPLETED"
  end

end