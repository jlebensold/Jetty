class Payment < ActiveRecord::Base
  belongs_to :purchaseable, :polymorphic => true
  validates :email, :presence => true, :email => true
  PAYPAL_PATH   = Rails.root.to_s + "/config/paypal_adaptive.yml"
end
