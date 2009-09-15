class AddGoalTotalColumn < ActiveRecord::Migration
  def self.up
    add_column :goals, :total, :integer, :default => 0
    add_column :goals, :status, :integer, :default => 0
  end

  def self.down
    remove_column :goals, :total
    remove_column :goals, :status
  end
end
