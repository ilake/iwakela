class CreateGoalDetails < ActiveRecord::Migration
  def self.up
    create_table :goal_details do |t|
      t.column :record_id, :integer
      t.column :user_id, :integer
      t.column :goal_id, :integer
      t.column :name, :string
      t.column :comment, :text
      t.column :done, :integer
      t.column :value, :float, :default => 0
      t.column :old_value, :float, :default => 0
      t.column :goal_type, :string
      t.column :rank, :integer, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :goal_details
  end
end
