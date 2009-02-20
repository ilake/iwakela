class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.integer :time_shift, :default => 3
      t.integer :open, :default => 0
      t.belongs_to :user
    end

    User.all.each do |u|
      Setting.create(:user_id => u.id)
    end
  end

  def self.down
    drop_table :settings
  end
end
