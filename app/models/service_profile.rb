# == Schema Information
# Schema version: 20090809070358
#
# Table name: service_profiles
#
#  id       :integer(4)      not null, primary key
#  user_id  :integer(4)      
#  service  :string(255)     
#  name     :string(255)     
#  password :string(255)     
#

#存plurk 之類帳號的
class ServiceProfile < ActiveRecord::Base
  belongs_to :user
end
