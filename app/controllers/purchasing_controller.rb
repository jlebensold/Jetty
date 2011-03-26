class PurchasingController < ApplicationController
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
end
