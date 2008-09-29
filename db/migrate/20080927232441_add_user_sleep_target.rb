class AddUserSleepTarget < ActiveRecord::Migration
  def self.up
    add_column :users, :sleep_target_time, :datetime
    add_column :targets, :todo_type, :integer, :default => 0
  end

  def self.down
    remove_column :users, :sleep_target_time
    remove_column :targets, :todo_type
  end
end
