class CreatePushes < ActiveRecord::Migration
  def self.up
    create_table :pushes do |t|
      t.belongs_to :user
      t.belongs_to :record
      t.timestamps
    end
  end

  def self.down
    drop_table :pushes
  end
end
