# == Schema Information
# Schema version: 20090809070358
#
# Table name: friends
#
#  user_id   :integer(4)      not null
#  friend_id :integer(4)      not null
#

class Friend < ActiveRecord::Base
  validates_uniqueness_of :user_id, :scope => :friend_id
end
