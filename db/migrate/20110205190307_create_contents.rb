class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.string "type"
      t.string "title"
      t.string "tagline"
      t.string "description"
      t.string "local_value"
      t.string "local_value_file_name"
      t.string "local_value_content_type"
      t.string "local_value_updated_at"
      t.string "remote_value"
      t.string "remote_value_file_name"
      t.string "remote_value_content_type"
      t.string "remote_value_updated_at"
      t.string "thumbnail"
      t.string "meta"
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
