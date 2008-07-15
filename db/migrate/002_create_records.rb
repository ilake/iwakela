class CreateRecords < ActiveRecord::Migration
  def self.up
    create_table :records do |t|
      t.column :todo_name, :string      
      t.column :todo_time, :datetime
      t.column :todo_target_time, :datetime
      t.column :user_id, :integer, :null => false
      t.column :content, :text
      t.column :success, :boolean, :default => true
    end
  end

  def self.down
    drop_table :records
  end
end
