# == Schema Information
# Schema version: 20090809070358
#
# Table name: scores
#
#  id      :integer(4)      not null, primary key
#  user_id :integer(4)      
#  name    :string(255)     
#  value   :integer(4)      
#

#好像是之前用來設定啥舉動多少分的, 現在好像沒用到
class Score < ActiveRecord::Base
  belongs_to :user
  named_scope :wake, :conditions => {:name => 'wake'}
  named_scope :sleep, :conditions => {:name => 'sleep'}
end
