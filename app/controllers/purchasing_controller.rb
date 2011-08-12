class PurchasingController < ApplicationController
  def index
    
  end
  
  def checkout

    @courseitem = CourseItem.find(params[:ci])
    @tracking_id = request.session_options[:id].reverse + "|" + current_user.id.to_s+"|course|"+@courseitem.id.to_s
    logger.info "[]: "+ @tracking_id
    pay_request = PaypalAdaptive::Request.new
    data = {
    "returnUrl" => @courseitem.monetize_return_url,
    "requestEnvelope" => {"errorLanguage" => "en_US"},
    "currencyCode"=>"USD",
    "receiverList"=>
        {"receiver"=>[
          {"email"=>@courseitem.content.creator.paypal_email, "amount"=>@courseitem.amount  }
#"primary" => true}
#chained:          ,{"email"=>"jon_1301144760_biz@lebensold.ca", "amount"=>"2.50", "primary" => false}
          ]
    },
    "cancelUrl"=>url_for(:action => 'index', :only_path => false),
    "trackingId" => @tracking_id,
    "actionType"=>"PAY",
    "ipnNotificationUrl"=>YAML.load_file(Payment::PAYPAL_PATH)[Rails.env]["ipn"]
    }
    
    pay_response = pay_request.pay(data)
    logger.info pay_response
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
    logger.info "IPN REQUEST!"
    #validate:
    paypal_response = IpnValidator.new(params, request.raw_post)
    logger.info ">>>validation..."
    logger.info paypal_response.valid?
    logger.info "tracker: " + params["tracking_id"].to_s
    p_split = params["tracking_id"].split('|')
    @user = User.find(p_split[1].to_i)
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