# == Schema Information
# Schema version: 20090809070358
#
# Table name: emails
#
#  id                :integer(4)      not null, primary key
#  from              :string(255)     
#  to                :string(255)     
#  last_send_attempt :integer(4)      default(0)
#  mail              :text            
#  created_on        :datetime        
#

class Email < ActiveRecord::Base
end
