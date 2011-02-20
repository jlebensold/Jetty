# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110212190749) do

  create_table "contents", :force => true do |t|
    t.string   "type"
    t.string   "title"
    t.string   "local_value"
    t.string   "local_value_file_name"
    t.string   "local_value_content_type"
    t.string   "local_value_updated_at"
    t.string   "remote_value"
    t.string   "remote_value_file_name"
    t.string   "remote_value_content_type"
    t.string   "remote_value_updated_at"
    t.string   "thumbnail"
    t.string   "status"
    t.integer  "parent_id"
    t.integer  "creator_id"
    t.date     "publish"
    t.date     "expire"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password"
    t.string   "paypal_username"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
