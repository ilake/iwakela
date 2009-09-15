# == Schema Information
# Schema version: 20090809070358
#
# Table name: statuses
#
#  id                     :integer(4)      not null, primary key
#  user_id                :integer(4)      
#  fight                  :boolean(1)      default(TRUE)
#  state                  :integer(4)      default(0)
#  average                :datetime        
#  success_rate           :float           
#  continuous_num         :integer(4)      
#  num                    :integer(4)      
#  last_record_created_at :datetime        
#  group_join_date        :datetime        
#  attendance             :float           
#  diff                   :integer(4)      
#  score                  :integer(4)      
#

#state 
#0 is 缺席
#1 is 成功 
#2 is 失敗
#3 is 請假
#4 is 太久沒來的
#last_record_created_at 最後一筆日誌的時間
#num 日誌的總數
class Status < ActiveRecord::Base
  belongs_to :user

  named_scope :long_time_no_see, :conditions => {:state => 4}
end
