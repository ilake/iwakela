class ChangeSatusesRateFloat < ActiveRecord::Migration
  def self.up
    change_column :statuses, :success_rate, :float
  end

  def self.down
    change_column :statuses, :success_rate, :integer
  end
end
