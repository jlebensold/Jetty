class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.string "type"
      t.string "title"
      t.string "value"
      t.string "value_file_name"
      t.string "value_content_type"
      t.string "thumbnail"
      t.string "status"
      t.integer "parent_id"
      t.integer "creator_id"
      t.date "publish"
      t.date "expire"
      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end
