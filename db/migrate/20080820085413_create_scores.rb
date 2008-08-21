class CreateScores < ActiveRecord::Migration
  def self.up
    create_table :scores do |t|
      t.belongs_to :user 
      t.string :name
      t.integer :value
    end
  end

  def self.down
    drop_table :scores
  end
end
