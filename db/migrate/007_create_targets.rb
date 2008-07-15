class CreateTargets < ActiveRecord::Migration
  def self.up
    create_table :targets do |t|
      t.column :user_id, :integer, :null => false
      t.column :todo_target_time, :datetime
      t.column :week, :integer
      t.column :month, :integer
    end
  end

  def self.down
    drop_table :targets
  end
end
