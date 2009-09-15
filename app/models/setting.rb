# == Schema Information
# Schema version: 20090809070358
#
# Table name: settings
#
#  id          :integer(4)      not null, primary key
#  time_shift  :integer(4)      default(3)
#  open        :integer(4)      default(0)
#  user_id     :integer(4)      
#  time_offset :float           default(0.0)
#  record_pri  :integer(4)      default(0)
#  census_pri  :integer(4)      default(0)
#  todo_pri    :integer(4)      default(0)
#

#time_shift : 換日線
#time_offset : 校正早鳥與user 端的誤差
#
#record_pri : default 日誌的private, public, 0是public, 1是private
class Setting < ActiveRecord::Base
  belongs_to :user
end
