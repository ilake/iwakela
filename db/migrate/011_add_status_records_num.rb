class AddStatusRecordsNum < ActiveRecord::Migration
  def self.up
    add_column :statuses, :num, :integer

    User.find(:all).each do |u|
      u.status.update_attribute(:num, u.records.size)
    end
  end

  def self.down
    remove_column :statuses, :num
  end
end
