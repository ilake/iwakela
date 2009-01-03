class AddForumPublic < ActiveRecord::Migration
  def self.up
    add_column :forums, :public, :integer
  end

  def self.down
    remove_column :forums, :public
  end
end
