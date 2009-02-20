class AddStatusLastRecord < ActiveRecord::Migration
  def self.up
    add_column :statuses, :last_record_created_at, :datetime

#    User.find(:all).each do |u|
#      unless u.records.blank?
#        u.status.update_attribute(:last_record_created_at, u.records.find_last_day)
#      end
#    end
  end

  def self.down
    remove_column :statuses, :last_record_created_at
  end
end
