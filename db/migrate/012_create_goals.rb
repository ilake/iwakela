class CreateGoals < ActiveRecord::Migration
  def self.up
    create_table :goals do |t|
      t.column :user_id, :integer
      t.column :choosed, :boolean
      t.column :done, :boolean
      t.column :name, :string
      t.column :comment, :text
    end
  end

  def self.down
    drop_table :goals
  end
end
