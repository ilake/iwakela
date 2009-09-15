# == Schema Information
# Schema version: 20090809070358
#
# Table name: goal_details
#
#  id         :integer(4)      not null, primary key
#  record_id  :integer(4)      
#  user_id    :integer(4)      
#  goal_id    :integer(4)      
#  name       :string(255)     
#  comment    :text            
#  done       :integer(4)      
#  value      :float           default(0.0)
#  old_value  :float           default(0.0)
#  goal_type  :string(255)     
#  rank       :integer(4)      default(0)
#  created_at :datetime        
#  updated_at :datetime        
#

class GoalDetail < ActiveRecord::Base
  validates_uniqueness_of :name, :scope => :record_id

  belongs_to :record
  belongs_to :goal

  named_scope :by_rank, :order => 'rank'
  named_scope :by_time, :order => 'updated_at DESC'
  named_scope :be_done, :conditions => {:done => 1}
end
