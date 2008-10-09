class AddGameDesc < ActiveRecord::Migration
  def self.up
    add_column :games, :desc, :text
  end

  def self.down
    remove_column :games, :desc
  end
end
