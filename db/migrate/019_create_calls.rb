class CreateCalls < ActiveRecord::Migration
  def self.up
    create_table :calls do |t|
      t.column :demander_id, :integer
      t.column :accepter_id, :integer
      t.column :title, :string
      t.column :time, :datetime
    end
  end

  def self.down
    drop_table :calls
  end
end
