class AddStatusDiff < ActiveRecord::Migration
  def self.up
    add_column :statuses, :diff, :integer
    add_column :records, :state, :integer
  end

  def self.down
    remove_column :statuses, :diff
    remove_column :records, :state
  end
end
