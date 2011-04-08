require 'spec_helper'
describe Payment do
  it { should belong_to(:purchaseable) }
  it "has amount and fk for content" do
    @payment = Factory(:payment)
    @payment.should be_kind_of Payment
  end

  it "can be associated with Content" do
   @content = Factory(:pdf)
   assert @content.save!
   @payment = Factory(:payment)
   @payment.purchaseable = @content
   assert @payment.save!
   @payment.purchaseable.should be_kind_of Pdf
  end

  it "can be associated with Course" do
    @c = Factory(:course)
    @payment = Factory(:payment)
    @payment.purchaseable = @c
    @payment.purchaseable.should be_kind_of Course
  end

  it "can make an adaptive payment" do
    @payment = Factory(:payment)
    pay_request = PaypalAdaptive::Request.new

    data = {
    "returnUrl" => "http://testserver.com/payments/completed_payment_request",
    "requestEnvelope" => {"errorLanguage" => "en_US"},
    "currencyCode"=>"USD",
    "receiverList"=>{"receiver"=>
        [{"email" => @payment.email , "amount"=>"10.00"}]
    },
    "cancelUrl"=>"http://testserver.com/payments/canceled_payment_request",
    "actionType"=>"PAY",
    "ipnNotificationUrl"=>"http://testserver.com/payments/ipn_notification"
    }

    pay_response = pay_request.pay(data)
    require 'pp'
    pp pay_response
    if pay_response.success?
     assert true
    else
      puts pay_response.errors.first['message']
    end
  end

end