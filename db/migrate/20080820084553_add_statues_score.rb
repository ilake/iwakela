class AddStatuesScore < ActiveRecord::Migration
  def self.up
    add_column :statuses, :score, :integer
  end

  def self.down
    remove_column :statuses, :score
  end
end
