class CreateChats < ActiveRecord::Migration
  def self.up
    create_table :chats do |t|
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :content, :text
    end
  end

  def self.down
    drop_table :chats
  end
end
