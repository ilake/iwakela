class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forums do |t|
      t.column :subject, :string
      t.column :content, :text
      t.column :created_at, :datetime
      t.column :user_id, :integer, :null => false
      t.column :comments_count, :integer, :default => 0
    end
  end

  def self.down
    drop_table :forums
  end
end
