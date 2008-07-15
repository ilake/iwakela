class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.column :user_id, :integer
      t.column :fight, :boolean, :default => true
      t.column :state, :integer, :default => 0
    end

    User.find(:all).each do |u|
      Status.create(:user_id => u.id)
    end
  end

  def self.down
    drop_table :statuses
  end
end
