class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.belongs_to :user
      t.string :name, :salt
      t.integer :num, :today_num, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
