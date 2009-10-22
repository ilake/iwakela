class GoalTotalIntegerToFloat < ActiveRecord::Migration
  def self.up
    change_column :goals, :total, :float
  end

  def self.down
    change_column :goals, :total, :float
  end
end
