class CreateAttrs < ActiveRecord::Migration
  def self.up
    create_table :attrs do |t|
      t.belongs_to :game
      t.string  :name
    end
  end

  def self.down
    drop_table :attrs
  end
end
