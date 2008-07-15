class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :name, :string
      t.column :created_at, :datetime
      t.column :content, :text
      t.column :record_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :comments
  end
end
