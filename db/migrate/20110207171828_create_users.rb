class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string  "email"
      t.string  "paypal_email"
      t.string  "paypal_return_address"
      t.string  "type"
      t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
      t.string   "password_salt",                       :default => "", :null => false
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string   "reset_password_token"
      t.string   "remember_token"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",                       :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.integer  "failed_attempts",                     :default => 0
      t.string   "unlock_token"
      t.datetime "locked_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "authentication_token"

    end
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :unlock_token,         :unique => true

  end

  def self.down
    drop_table :users
  end
end
