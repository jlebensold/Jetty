class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.boolean :monetize, :default => false, :null => false
      t.decimal :amount, :precision => 8, :scale => 2
      t.string  :monetize_return_url
      t.string :title
      t.string :description
      t.string :monetize_return_url
      t.integer "creator_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
