# == Schema Information
# Schema version: 20080819065738
#
# Table name: goals
#
#  id      :integer(11)     not null, primary key
#  user_id :integer(11)     
#  choosed :integer(11)     
#  done    :boolean(1)      
#  name    :string(255)     
#  comment :text            
#

class Goal < ActiveRecord::Base
  named_scope :active, :conditions => ["goals.choosed <> ?", '-1']
  named_scope :temp, :conditions => ["goals.choosed = ?", '-1']
  belongs_to :user
end
