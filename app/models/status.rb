# == Schema Information
# Schema version: 20080819065738
#
# Table name: statuses
#
#  id                     :integer(11)     not null, primary key
#  user_id                :integer(11)     
#  fight                  :boolean(1)      default(TRUE)
#  state                  :integer(11)     default(0)
#  average                :datetime        
#  success_rate           :float           
#  continuous_num         :integer(11)     
#  num                    :integer(11)     
#  last_record_created_at :datetime        
#  group_join_date        :datetime        
#  attendance             :float           default(0.0)
#  diff                   :integer(11)     
#

#state 
#0 is 缺席
#1 is 成功 
#2 is 失敗
#3 is 請假
class Status < ActiveRecord::Base
  belongs_to :user
end
