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

ActiveRecord::Schema.define(:version => 20091019034306) do

  create_table "about_states", :force => true do |t|
    t.integer "user_id"
    t.string  "confirm_email_code"
    t.date    "confirm_email_until"
    t.boolean "confirm_email"
  end

  add_index "about_states", ["confirm_email_code"], :name => "index_about_states_on_confirm_email_code"
  add_index "about_states", ["user_id"], :name => "index_about_states_on_user_id"

  create_table "attrs", :force => true do |t|
    t.integer "game_id"
    t.string  "name"
  end

  add_index "attrs", ["game_id"], :name => "index_attrs_on_game_id"

  create_table "calls", :force => true do |t|
    t.integer  "demander_id"
    t.integer  "accepter_id"
    t.string   "title"
    t.datetime "time"
  end

  add_index "calls", ["accepter_id"], :name => "index_calls_on_accepter_id"
  add_index "calls", ["demander_id"], :name => "index_calls_on_demander_id"
  add_index "calls", ["id"], :name => "index_calls_on_id"

  create_table "chats", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.text     "content"
    t.integer  "group_id"
  end

  add_index "chats", ["group_id"], :name => "index_chats_on_group_id"
  add_index "chats", ["user_id"], :name => "index_chats_on_user_id"

  create_table "comments", :force => true do |t|
    t.datetime "created_at"
    t.text     "content"
    t.integer  "record_id",   :null => false
    t.string   "record_type"
    t.integer  "user_id"
  end

  add_index "comments", ["record_id", "record_type"], :name => "index_comments_on_record_id_and_record_type"
  add_index "comments", ["record_id", "user_id"], :name => "index_comments_on_record_id_and_user_id"
  add_index "comments", ["record_type"], :name => "index_comments_on_record_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

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

  add_index "fight_methods", ["game_id"], :name => "index_fight_methods_on_game_id"
  add_index "fight_methods", ["id"], :name => "index_fight_methods_on_id"

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

  add_index "forums", ["group_id"], :name => "index_forums_on_group_id"
  add_index "forums", ["id"], :name => "index_forums_on_id"
  add_index "forums", ["user_id"], :name => "index_forums_on_user_id"

  create_table "friends", :id => false, :force => true do |t|
    t.integer "user_id",   :null => false
    t.integer "friend_id", :null => false
  end

  add_index "friends", ["friend_id", "user_id"], :name => "index_friends_on_friend_id_and_user_id"

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

  add_index "games", ["id"], :name => "index_games_on_id"

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
  add_index "goal_details", ["record_id"], :name => "index_goal_details_on_record_id"

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

  add_index "goals", ["id"], :name => "index_goals_on_id"
  add_index "goals", ["user_id"], :name => "index_goals_on_user_id"

  create_table "great_words", :force => true do |t|
    t.text    "content"
    t.integer "user_id"
  end

  add_index "great_words", ["id"], :name => "index_great_words_on_id"
  add_index "great_words", ["user_id"], :name => "index_great_words_on_user_id"

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

  add_index "groups", ["id"], :name => "index_groups_on_id"
  add_index "groups", ["owner_id"], :name => "index_groups_on_owner_id"

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

  add_index "messages", ["id"], :name => "index_messages_on_id"
  add_index "messages", ["master_id"], :name => "index_messages_on_master_id"
  add_index "messages", ["message_id"], :name => "index_messages_on_message_id"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

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

  add_index "mugshots", ["group_id"], :name => "index_mugshots_on_group_id"
  add_index "mugshots", ["id"], :name => "index_mugshots_on_id"
  add_index "mugshots", ["parent_id"], :name => "index_mugshots_on_parent_id"
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

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "pushes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "record_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pushes", ["record_id"], :name => "index_pushes_on_record_id"
  add_index "pushes", ["user_id"], :name => "index_pushes_on_user_id"

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

  add_index "records", ["id"], :name => "index_records_on_id"
  add_index "records", ["todo_name"], :name => "index_records_on_todo_name"
  add_index "records", ["todo_time"], :name => "index_records_on_todo_time"
  add_index "records", ["user_id"], :name => "index_records_on_user_id"

  create_table "scores", :force => true do |t|
    t.integer "user_id"
    t.string  "name"
    t.integer "value"
  end

  add_index "scores", ["user_id"], :name => "index_scores_on_user_id"

  create_table "service_profiles", :force => true do |t|
    t.integer "user_id"
    t.string  "service"
    t.string  "name"
    t.string  "password"
  end

  add_index "service_profiles", ["user_id"], :name => "index_service_profiles_on_user_id"

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

  add_index "talks", ["game_id"], :name => "index_talks_on_game_id"

  create_table "targets", :force => true do |t|
    t.integer  "user_id",                         :null => false
    t.datetime "todo_target_time"
    t.integer  "week"
    t.integer  "month"
    t.integer  "todo_type",        :default => 0
  end

  add_index "targets", ["user_id"], :name => "index_targets_on_user_id"

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

  add_index "tiny_mce_photos", ["parent_id"], :name => "index_tiny_mce_photos_on_parent_id"
  add_index "tiny_mce_photos", ["user_id"], :name => "index_tiny_mce_photos_on_user_id"

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

  add_index "users", ["group_id"], :name => "index_users_on_group_id"
  add_index "users", ["id"], :name => "index_users_on_id"
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["yahoo_userhash"], :name => "index_users_on_yahoo_userhash"

end
