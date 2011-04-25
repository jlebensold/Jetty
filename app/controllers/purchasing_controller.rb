class PurchasingController < ApplicationController
  def index
    
  end
  
  def checkout
    @myip   = "46.116.102.123"
    @ipn    = "http://#{@myip}:3000/purchasing/ipn"
    @courseitem = CourseItem.find(params[:ci])
    #TODO: check if already paid

    
    pay_request = PaypalAdaptive::Request.new
    data = {
    "returnUrl" => @courseitem.monetize_return_url,
    "requestEnvelope" => {"errorLanguage" => "en_US"},
    "currencyCode"=>"USD",
    "receiverList"=>
        {"receiver"=>[
          {"email"=>"Merch1_1301751699_biz@lebensold.ca", "amount"=>@courseitem.amount }
#"primary" => true}
#chained:          ,{"email"=>"jon_1301144760_biz@lebensold.ca", "amount"=>"2.50", "primary" => false}
          ]
    },
    "cancelUrl"=>url_for(:action => 'index', :only_path => false),
    "trackingId" => current_user.id.to_s+"|course|"+@courseitem.id.to_s,
    "actionType"=>"PAY",
    "ipnNotificationUrl"=>@ipn
    }
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
    @courseitem = CourseItem.find(p_split.last.to_i)
    payment = Payment.new
    payment.email = @user.email
    payment.purchaseable = @courseitem.content
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