class PurchasingController < ApplicationController
  def index
    
  end

  def checkout
    session[:purchased] = nil
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
=begin
PASS the customerId which is the Pkey of the current_user id
on IPN, update the purchase table with the customer ID, unlocking the digital asset
      =BEGIN asdasdasd!!! CURRENT USER!!!
=end
    "customerId" => current_user.id,
    "actionType"=>"PAY",
    "ipnNotificationUrl"=>"http://93.173.59.38:3000/purchasing/ipn"
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
    #TODO: validate payment values
    session[:purchased] = true;
    require 'PP'
    logger.info ">>>>>"
    logger.info pp params
    logger.info "<<<<<"
  end
=begin
  include ActiveMerchant::Billing

  def checkout
    setup_response = gateway.setup_purchase(5000,
      :ip                => request.remote_ip,
      :return_url        => url_for(:action => 'confirm', :only_path => false),
      :cancel_return_url => url_for(:action => 'index', :only_path => false)
    )
    redirect_to gateway.redirect_url_for(setup_response.token)
  end
private
  def gateway
    @gateway ||= PaypalExpressGateway.new(
      :login => 'BBB_1218238161_biz_api1.lebensold.ca',
      :password => '1218238166',
      :signature => 'As4faK2yva3w7w7kh9gXwOx0CHCeAAec5zQWJP04DYX1lCgRY0nbzeCV '
    )
  end
=end
end
