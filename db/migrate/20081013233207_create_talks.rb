class CreateTalks < ActiveRecord::Migration
  def self.up
    create_table :talks do |t|
      t.belongs_to :game
      t.string     :name
      t.text       :content
      t.datetime   :created_at
    end
  end

  def self.down
    drop_table :talks
  end
end
