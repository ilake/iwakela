class ChangeGoalChooseBoolToInteger < ActiveRecord::Migration
  def self.up
    change_column :goals, :choosed, :integer
  end

  def self.down
  end
end
