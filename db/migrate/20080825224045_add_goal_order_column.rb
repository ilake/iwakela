class AddGoalOrderColumn < ActiveRecord::Migration
  def self.up
    add_column :goals, :rank, :integer, :default => 0
  end

  def self.down
    remove_column :goals, :rank
  end
end
