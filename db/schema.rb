# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080708135905) do

  create_table "calls", :force => true do |t|
    t.integer  "demander_id"
    t.integer  "accepter_id"
    t.string   "title"
    t.datetime "time"
  end

  create_table "chats", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.text     "content"
    t.integer  "group_id"
  end

  create_table "comments", :force => true do |t|
    t.datetime "created_at"
    t.text     "content"
    t.integer  "record_id",   :null => false
    t.string   "record_type"
    t.integer  "user_id"
  end

  create_table "forums", :force => true do |t|
    t.string   "subject"
    t.text     "content"
    t.datetime "created_at"
    t.integer  "user_id",                       :null => false
    t.integer  "comments_count", :default => 0
    t.integer  "group_id"
  end

  create_table "goals", :force => true do |t|
    t.integer "user_id"
    t.boolean "choosed"
    t.boolean "done"
    t.string  "name"
    t.text    "comment"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "board"
    t.text     "condition"
    t.integer  "user_num"
    t.integer  "state",      :default => 0
    t.datetime "created_at"
    t.integer  "owner_id"
  end

  create_table "mugshots", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
  end

  create_table "profiles", :force => true do |t|
    t.integer "user_id"
    t.text    "others"
    t.string  "sex"
    t.text    "birth"
    t.string  "star"
    t.string  "blood"
    t.string  "address"
    t.string  "school"
    t.string  "job"
    t.string  "interest"
    t.string  "photo"
    t.string  "connect"
    t.boolean "email_weekly", :default => true
  end

  create_table "records", :force => true do |t|
    t.string   "todo_name"
    t.datetime "todo_time"
    t.datetime "todo_target_time"
    t.integer  "user_id",                            :null => false
    t.text     "content"
    t.boolean  "success",          :default => true
    t.text     "goal"
    t.text     "com_goal"
    t.integer  "state"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"
  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

  create_table "statuses", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "fight",                  :default => true
    t.integer  "state",                  :default => 0
    t.datetime "average"
    t.float    "success_rate"
    t.integer  "continuous_num"
    t.integer  "num"
    t.datetime "last_record_created_at"
    t.datetime "group_join_date"
    t.float    "attendance"
    t.integer  "diff"
  end

  create_table "targets", :force => true do |t|
    t.integer  "user_id",          :null => false
    t.datetime "todo_target_time"
    t.integer  "week"
    t.integer  "month"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "password_salt"
    t.string   "password_hash"
    t.string   "email"
    t.datetime "created_at"
    t.string   "cookie_hash"
    t.datetime "target_time_now"
    t.string   "reset_password_code"
    t.datetime "reset_password_code_until"
    t.string   "yahoo_userhash"
    t.integer  "group_id"
    t.string   "group_nickname"
    t.string   "time_zone",                 :default => "Taipei"
  end

end
