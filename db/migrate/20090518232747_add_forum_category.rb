class AddForumCategory < ActiveRecord::Migration
  def self.up
    add_column :forums, :category, :string
  end

  def self.down
    remove_column :forumns, :category
  end
end
