class AddRecordComment2Title < ActiveRecord::Migration
  def self.up
    add_column :records, :title, :string
    add_column :records, :content2, :text
    add_column :records, :push_count, :integer, :default => 0
  end

  def self.down
    remove_column :records, :title
    remove_column :records, :content2
    remove_column :records, :push_count
  end
end
