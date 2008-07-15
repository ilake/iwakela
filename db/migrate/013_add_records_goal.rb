class AddRecordsGoal < ActiveRecord::Migration
  def self.up
    add_column :records, :goal, :text
    add_column :records, :com_goal, :text
  end

  def self.down
    remove_column :records, :goal
    remove_column :records, :com_goal
  end
end
