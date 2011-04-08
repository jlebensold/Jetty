class CreateCourseItems < ActiveRecord::Migration
  def self.up
    create_table :course_items do |t|
      t.boolean :monetize, :default => false, :null => false
      t.decimal :amount, :precision => 8, :scale => 2
      t.integer :course_id
      t.integer :content_id
      t.integer :ordering, :default => 0, :null => false
      t.timestamps
    endzø
  end

  def self.down
    drop_table :course_items
  end
end
