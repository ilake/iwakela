# == Schema Information
# Schema version: 20
#
# Table name: goals
#
#  id      :integer(11)     not null, primary key
#  user_id :integer(11)     
#  choosed :boolean(1)      
#  done    :boolean(1)      
#  name    :string(255)     
#  comment :text            
#

class Goal < ActiveRecord::Base
  belongs_to :user
end
