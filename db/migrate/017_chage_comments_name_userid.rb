class ChageCommentsNameUserid < ActiveRecord::Migration
  def self.up
    #Comment.delete_all
    remove_column :comments, :name
    add_column :comments, :user_id, :integer
  end

  def self.down
    remove_column :comments, :user_id
    add_column :comments, :name, :string
  end
end
