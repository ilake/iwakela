# == Schema Information
# Schema version: 20080916232411
#
# Table name: targets
#
#  id               :integer(11)     not null, primary key
#  user_id          :integer(11)     not null
#  todo_target_time :datetime        
#  week             :integer(11)     
#  month            :integer(11)     
#

class Target < ActiveRecord::Base
  belongs_to :user

  named_scope :wake, :conditions => {:todo_type => 0}
  named_scope :sleep, :conditions => {:todo_type => 1}
end
