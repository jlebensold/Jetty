class PaymentsController < BasePublisherController
  before_filter :payment_allowed
  def payment_allowed
    unless current_user != nil && current_user.type == "Administrator"
      flash[:error] = "Administrators only"
      redirect_to :controller => "home", :action => "index"
    end
  end
  def delete
    Payment.find(params[:id]).delete
    redirect_to :controller => "users", :action => "index"
  end
  def create
    logger.info ">>>>>"
    @payment = Payment.new(params[:payment])
    @payment.save
    redirect_to :controller => "users", :action => "index"
  end
end
