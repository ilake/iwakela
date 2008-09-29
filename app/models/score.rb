# == Schema Information
# Schema version: 20080916232411
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
end
