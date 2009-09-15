class AddManyTableIndex < ActiveRecord::Migration
  def self.up
    add_index :records, :user_id
    add_index :records, :todo_name
    add_index :records, :todo_time
    add_index :goals, :user_id
    add_index :goal_details, :goal_id
    add_index :forums, :user_id
    add_index :settings, :user_id
    add_index :statuses, :user_id
    add_index :mugshots, :user_id
    add_index :comments, [:record_id, :user_id]
    add_index :comments, :record_type
  end

  def self.down
    remove_index :records, :user_id
    remove_index :records, :todo_name
    remove_index :records, :todo_time
    remove_index :goals, :user_id
    remove_index :goal_details, :goal_id
    remove_index :forums, :user_id
    remove_index :statuses, :user_id
    remove_index :settings, :user_id
    remove_index :mugshots, :user_id
    remove_index :comments, [:record_id, :user_id]
    remove_index :comments, :record_type
  end
end
