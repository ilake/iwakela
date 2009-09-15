class AddSettingPrivateSettingColumn < ActiveRecord::Migration
  def self.up
    add_column :settings, :record_pri, :integer, :default => 0
    add_column :settings, :census_pri, :integer, :default => 0
    add_column :settings, :todo_pri, :integer, :default => 0
    add_column :settings, :friend_pri, :integer, :default => 0

    add_column :records, :pri, :integer, :default => 0
  end

  def self.down
    remove_column :settings, :record_pri
    remove_column :settings, :census_pri
    remove_column :settings, :todo_pri
    remove_column :settings, :friend_pri

    remove_column :records, :pri
  end
end
