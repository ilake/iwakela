# == Schema Information
# Schema version: 20080916232411
#
# Table name: friends
#
#  user_id   :integer(11)     not null
#  friend_id :integer(11)     not null
#

class Friend < ActiveRecord::Base
end
