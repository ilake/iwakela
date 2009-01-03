# == Schema Information
# Schema version: 20081227162431
#
# Table name: scores
#
#  id      :integer(11)     not null, primary key
#  user_id :integer(11)     
#  name    :string(255)     
#  value   :integer(11)     
#

class Score < ActiveRecord::Base
  belongs_to :user
  named_scope :wake, :conditions => {:name => 'wake'}
  named_scope :sleep, :conditions => {:name => 'sleep'}
end
