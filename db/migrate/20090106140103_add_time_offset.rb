class AddTimeOffset < ActiveRecord::Migration
  def self.up
    add_column :settings, :time_offset, :float, :default => 0
  end

  def self.down
    remove_column :settings, :time_offset
  end
end
