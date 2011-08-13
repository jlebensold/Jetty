class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.decimal :amount, :precision => 8, :scale => 2
      t.integer :product_id
      t.integer :purchaseable_id
      t.string  :purchaseable_type
      t.string  :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
