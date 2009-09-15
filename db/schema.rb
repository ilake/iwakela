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

ActiveRecord::Schema.define(:version => 20090909054105) do

  create_table "about_states", :force => true do |t|
    t.integer "user_id"
    t.string  "confirm_email_code"
    t.date    "confirm_email_until"
    t.boolean "confirm_email"
  end

  create_table "attrs", :force => true do |t|
    t.integer "game_id"
    t.string  "name"
  end

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

  add_index "comments", ["record_id", "user_id"], :name => "index_comments_on_record_id_and_user_id"
  add_index "comments", ["record_type"], :name => "index_comments_on_record_type"

  create_table "emails", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.integer  "last_send_attempt", :default => 0
    t.text     "mail"
    t.datetime "created_on"
  end

  create_table "feature_methods", :force => true do |t|
    t.integer "fight_method_id"
    t.integer "fight_group_id"
  end

  create_table "fight_groups", :force => true do |t|
    t.integer "game_id"
    t.string  "name"
  end

  create_table "fight_methods", :force => true do |t|
    t.integer "game_id"
    t.string  "name"
    t.integer "fight_type", :default => 0
    t.integer "value",      :default => 0
  end

  create_table "foos", :force => true do |t|
    t.integer  "forum_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forums", :force => true do |t|
    t.string   "subject"
    t.text     "content"
    t.datetime "created_at"
    t.integer  "user_id",                          :null => false
    t.integer  "comments_count",    :default => 0
    t.integer  "group_id"
    t.datetime "last_comment_time"
    t.integer  "public"
    t.string   "category"
  end

  add_index "forums", ["user_id"], :name => "index_forums_on_user_id"

  create_table "friends", :id => false, :force => true do |t|
    t.integer "user_id",   :null => false
    t.integer "friend_id", :null => false
  end

  create_table "games", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "salt"
    t.integer  "num",        :default => 0
    t.integer  "today_num",  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "desc"
    t.string   "pass_code"
  end

  create_table "goal_details", :force => true do |t|
    t.integer  "record_id"
    t.integer  "user_id"
    t.integer  "goal_id"
    t.string   "name"
    t.text     "comment"
    t.integer  "done"
    t.float    "value",      :default => 0.0
    t.float    "old_value",  :default => 0.0
    t.string   "goal_type"
    t.integer  "rank",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goal_details", ["goal_id"], :name => "index_goal_details_on_goal_id"

  create_table "goals", :force => true do |t|
    t.integer "user_id"
    t.integer "choosed"
    t.boolean "done"
    t.string  "name"
    t.text    "comment"
    t.integer "rank",    :default => 0
    t.integer "total",   :default => 0
    t.integer "status",  :default => 0
  end

  add_index "goals", ["user_id"], :name => "index_goals_on_user_id"

  create_table "great_words", :force => true do |t|
    t.text    "content"
    t.integer "user_id"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "board"
    t.text     "condition"
    t.integer  "user_num"
    t.integer  "state",         :default => 0
    t.datetime "created_at"
    t.integer  "owner_id"
    t.integer  "chats_num"
    t.integer  "members_count"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "master_id"
    t.string   "subject"
    t.text     "content"
    t.integer  "public"
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "group_id"
  end

  add_index "mugshots", ["user_id"], :name => "index_mugshots_on_user_id"

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
    t.text    "dream_word"
  end

  create_table "pushes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "record_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "readed",           :default => 0
    t.string   "feeling"
    t.string   "title"
    t.text     "content2"
    t.integer  "push_count",       :default => 0
    t.integer  "pri",              :default => 0
  end

  add_index "records", ["todo_name"], :name => "index_records_on_todo_name"
  add_index "records", ["todo_time"], :name => "index_records_on_todo_time"
  add_index "records", ["user_id"], :name => "index_records_on_user_id"

  create_table "scores", :force => true do |t|
    t.integer "user_id"
    t.string  "name"
    t.integer "value"
  end

  create_table "service_profiles", :force => true do |t|
    t.integer "user_id"
    t.string  "service"
    t.string  "name"
    t.string  "password"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.integer "time_shift",  :default => 3
    t.integer "open",        :default => 0
    t.integer "user_id"
    t.float   "time_offset", :default => 0.0
    t.integer "record_pri",  :default => 0
    t.integer "census_pri",  :default => 0
    t.integer "todo_pri",    :default => 0
    t.integer "friend_pri",  :default => 0
  end

  add_index "settings", ["user_id"], :name => "index_settings_on_user_id"

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
    t.integer  "score"
  end

  add_index "statuses", ["user_id"], :name => "index_statuses_on_user_id"

  create_table "talks", :force => true do |t|
    t.integer  "game_id"
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
  end

  create_table "targets", :force => true do |t|
    t.integer  "user_id",                         :null => false
    t.datetime "todo_target_time"
    t.integer  "week"
    t.integer  "month"
    t.integer  "todo_type",        :default => 0
  end

  create_table "tiny_mce_photos", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.datetime "sleep_target_time"
  end

end
