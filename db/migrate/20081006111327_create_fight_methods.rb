class CreateFightMethods < ActiveRecord::Migration
  def self.up
    create_table :fight_methods do |t|
      t.belongs_to :game
      t.string :name
      t.integer :fight_type, :value, :default => 0
    end
  end

  def self.down
    drop_table :fight_methods
  end
end
