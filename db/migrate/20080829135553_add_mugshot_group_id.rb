class AddMugshotGroupId < ActiveRecord::Migration
  def self.up
    add_column :mugshots, :group_id, :integer
  end

  def self.down
    remove_column :mugshots, :group_id
  end
end
