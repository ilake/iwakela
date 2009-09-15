class AddRecordFeelingColumn < ActiveRecord::Migration
  def self.up
    add_column :records, :feeling, :string
  end

  def self.down
    remove_column :records, :feeling
  end
end
