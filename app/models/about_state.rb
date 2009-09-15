# == Schema Information
# Schema version: 20090809070358
#
# Table name: about_states
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)      
#  confirm_email_code  :string(255)     
#  confirm_email_until :date            
#  confirm_email       :boolean(1)      
#


#用來存email 是否認證
class AboutState < ActiveRecord::Base
  #validates_uniqueness_of :confirm_email_code
  belongs_to :user
end
