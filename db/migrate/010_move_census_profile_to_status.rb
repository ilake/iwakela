class MoveCensusProfileToStatus < ActiveRecord::Migration
  def self.up
    add_column :statuses, :average, :datetime
    add_column :statuses, :success_rate, :integer
    add_column :statuses, :continuous_num, :integer
    
#    User.find(:all).each do |u|
#      u.status.update_attributes(:average => u.profile.average,
#                               :success_rate => u.profile.success_rate,
#                               :continuous_num => u.profile.continuous_num)
#    end

    remove_column :profiles, :average
    remove_column :profiles, :success_rate
    remove_column :profiles, :continuous_num
  end

  def self.down
    remove_column :statuses, :average
    remove_column :statuses, :success_rate
    remove_column :statuses, :continuous_num
  end
end
