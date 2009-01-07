# == Schema Information
# Schema version: 20081227162431
#
# Table name: settings
#
#  id         :integer(11)     not null, primary key
#  time_shift :integer(11)     default(3)
#  open       :integer(11)     default(0)
#  user_id    :integer(11)     
#

#time_shift : 換日線
#time_offset : 校正早鳥與user 端的誤差
class Setting < ActiveRecord::Base
  belongs_to :user
end
