class AddGamePassCode < ActiveRecord::Migration
  def self.up
    add_column :games, :pass_code, :string
  end

  def self.down
    remove_column :games, :pass_code
  end
end
