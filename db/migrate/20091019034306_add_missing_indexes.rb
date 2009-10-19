class AddMissingIndexes < ActiveRecord::Migration
  def self.up
    check_add_index :groups, :id
    check_add_index :about_states, :confirm_email_code
    check_add_index :messages, :id
    check_add_index :games, :id
    check_add_index :goals, :id
    check_add_index :great_words, :id
    check_add_index :fight_methods, :id
    check_add_index :records, :id
    check_add_index :forums, :id
    check_add_index :mugshots, :id
    check_add_index :users, :id
    check_add_index :users, :name
    check_add_index :users, :yahoo_userhash
    check_add_index :calls, :id

    check_add_index :about_states, :user_id  
    check_add_index :groups, :owner_id
    check_add_index :pushes, :record_id
    check_add_index :pushes, :user_id
    check_add_index :profiles, :user_id
    check_add_index :friends, [:friend_id, :user_id]
    check_add_index :messages, :user_id
    check_add_index :messages, :message_id   
    check_add_index :messages, :master_id
    check_add_index :service_profiles, :user_id
    check_add_index :goals, :user_id
    check_add_index :attrs, :game_id
    check_add_index :comments, [:record_id, :record_type]
    check_add_index :comments, :user_id
    check_add_index :goal_details, :record_id
    check_add_index :goal_details, :goal_id  
    check_add_index :great_words, :user_id   
    check_add_index :fight_methods, :game_id 
    check_add_index :scores, :user_id
    check_add_index :statuses, :user_id
    check_add_index :targets, :user_id
    check_add_index :records, :user_id
    check_add_index :forums, :group_id
    check_add_index :forums, :user_id
    check_add_index :settings, :user_id
    check_add_index :chats, :group_id
    check_add_index :chats, :user_id
    check_add_index :tiny_mce_photos, :user_id
    check_add_index :tiny_mce_photos, :parent_id
    check_add_index :mugshots, :group_id
    check_add_index :mugshots, :user_id
    check_add_index :mugshots, :parent_id
    check_add_index :users, :group_id
    check_add_index :talks, :game_id
    check_add_index :calls, :demander_id
    check_add_index :calls, :accepter_id

  end

  def self.down
    check_remove_index :groups, :id
    check_remove_index :about_states, :confirm_email_code
    check_remove_index :messages, :id
    check_remove_index :games, :id
    check_remove_index :goals, :id
    check_remove_index :great_words, :id
    check_remove_index :fight_methods, :id   
    check_remove_index :records, :id
    check_remove_index :forums, :id
    check_remove_index :mugshots, :id
    check_remove_index :users, :id
    check_remove_index :users, :name
    check_remove_index :users, :yahoo_userhash
    check_remove_index :calls, :id

    check_remove_index :about_states, :user_id
    check_remove_index :groups, :owner_id
    check_remove_index :pushes, :record_id   
    check_remove_index :pushes, :user_id
    check_remove_index :profiles, :user_id   
    check_remove_index :friends, :column => [:friend_id, :user_id]
    check_remove_index :messages, :user_id   
    check_remove_index :messages, :message_id
    check_remove_index :messages, :master_id 
    check_remove_index :service_profiles, :user_id
    check_remove_index :goals, :user_id
    check_remove_index :attrs, :game_id
    check_remove_index :comments, :column => [:record_id, :record_type]
    check_remove_index :comments, :user_id   
    check_remove_index :goal_details, :record_id
    check_remove_index :goal_details, :goal_id
    check_remove_index :great_words, :user_id
    check_remove_index :fight_methods, :game_id
    check_remove_index :scores, :user_id
    check_remove_index :statuses, :user_id   
    check_remove_index :targets, :user_id
    check_remove_index :records, :user_id
    check_remove_index :forums, :group_id
    check_remove_index :forums, :user_id
    check_remove_index :settings, :user_id   
    check_remove_index :chats, :group_id
    check_remove_index :chats, :user_id
    check_remove_index :tiny_mce_photos, :user_id
    check_remove_index :tiny_mce_photos, :parent_id
    check_remove_index :mugshots, :group_id  
    check_remove_index :mugshots, :user_id
    check_remove_index :mugshots, :parent_id
    check_remove_index :users, :group_id
    check_remove_index :talks, :game_id
    check_remove_index :calls, :demander_id
    check_remove_index :calls, :accepter_id
  end

  def self.check_add_index(table, column)
    add_index table, column unless check_index_exist(table, column)
  end

  def self.check_remove_index(table, column)
    remove_index table, column if check_index_exist(table, column)
  end

  def self.check_index_exist(table, columns)
    ActiveRecord::Base.connection.indexes(table).map(&:name).include?(ActiveRecord::Base.connection.index_name(table, columns))
  end

end
