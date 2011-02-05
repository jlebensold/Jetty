class CreateUserTypes < ActiveRecord::Migration
  def self.up
    create_table :user_types do |t|
      t.string :name
      t.integer :permission_code
      t.timestamps
    end
    UserType.create :name => "admin",     :permission_code =>1
    UserType.create :name => "publisher", :permission_code => 200
    UserType.create :name => "student" , :permission_code =>300


  end

  def self.down
    drop_table :user_types
  end
end
