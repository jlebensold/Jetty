class Payment < ActiveRecord::Base
  belongs_to :purchaseable, :polymorphic => true
  belongs_to :user
  
  validates :user_id, :presence => true
  PAYPAL_PATH   = Rails.root.to_s + "/config/paypal_adaptive.yml"
end
