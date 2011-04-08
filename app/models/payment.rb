class Payment < ActiveRecord::Base
  belongs_to :purchaseable, :polymorphic => true
  validates :email, :presence => true, :email => true

end
