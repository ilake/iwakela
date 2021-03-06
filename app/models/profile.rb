# == Schema Information
# Schema version: 20090809070358
#
# Table name: profiles
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)      
#  others       :text            
#  sex          :string(255)     
#  birth        :text            
#  star         :string(255)     
#  blood        :string(255)     
#  address      :string(255)     
#  school       :string(255)     
#  job          :string(255)     
#  interest     :string(255)     
#  photo        :string(255)     
#  connect      :string(255)     
#  email_weekly :boolean(1)      default(TRUE)
#  dream_word   :text            
#

class Profile < ActiveRecord::Base
  belongs_to :user
end
