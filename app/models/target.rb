# == Schema Information
# Schema version: 20090809070358
#
# Table name: targets
#
#  id               :integer(4)      not null, primary key
#  user_id          :integer(4)      not null
#  todo_target_time :datetime        
#  week             :integer(4)      
#  month            :integer(4)      
#  todo_type        :integer(4)      default(0)
#

class Target < ActiveRecord::Base
  belongs_to :user

  named_scope :wake, :conditions => {:todo_type => 0}
  named_scope :sleep, :conditions => {:todo_type => 1}
end
