class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.column :name, :string
      t.column :board, :text
      t.column :condition, :text
      t.column :user_num, :integer
      t.column :state, :integer, :default => 0
      t.column :created_at, :datetime
      t.column :owner_id, :integer
    end

    add_column :users, :group_id, :integer
    add_column :users, :group_nickname, :string
    add_column :statuses, :group_join_date, :datetime
    add_column :statuses, :attendance, :float
    add_column :chats, :group_id, :integer
    add_column :forums, :group_id, :integer
  end

  def self.down
    drop_table :groups
    remove_column :users, :group_id
    remove_column :users, :group_nickname
    remove_column :statuses, :attendance
    remove_column :statuses, :group_join_date
    remove_column :chats, :group_id
    remove_column :forums, :group_id
  end
end
