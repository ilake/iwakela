class AddRecordReaded < ActiveRecord::Migration
  def self.up
    add_column :records, :readed, :integer, :default => 0
  end

  def self.down
    remove_column :records, :readed
  end
end
