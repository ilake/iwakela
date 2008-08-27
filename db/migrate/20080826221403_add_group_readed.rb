class AddGroupReaded < ActiveRecord::Migration
  def self.up
    add_column :groups, :readed, :integer, :default => 0
  end

  def self.down
    remove_column :groups, :readed
  end
end
