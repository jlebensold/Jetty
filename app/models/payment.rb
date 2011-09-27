class Payment < ActiveRecord::Base
  belongs_to :purchaseable, :polymorphic => true
  belongs_to :user
  
  validates :user_id, :presence => true
  PAYPAL_PATH   = Rails.root.to_s + "/config/paypal_adaptive.yml"
 def as_json(options = {})
    if (options == nil)
      options = {}
    end
    options.merge({
      :id => id,
      :title => purchaseable.title,
      :purchaseable_type => purchaseable_type
    })
 end
end
