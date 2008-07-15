# == Schema Information
# Schema version: 20
#
# Table name: profiles
#
#  id           :integer(11)     not null, primary key
#  user_id      :integer(11)     
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
#

class Profile < ActiveRecord::Base
  belongs_to :user
end
