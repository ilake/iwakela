# == Schema Information
# Schema version: 20090809070358
#
# Table name: messages
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)      
#  master_id  :integer(4)      
#  subject    :string(255)     
#  content    :text            
#  public     :integer(4)      
#  message_id :integer(4)      
#  created_at :datetime        
#  updated_at :datetime        
#

#public  0:公開 1:隱藏
class Message < ActiveRecord::Base
  validates_presence_of :subject, :content, :public

  belongs_to :user
  belongs_to :owner, :class_name => 'User', :foreign_key => "master_id"
  has_one :reply, :class_name => 'Message', :foreign_key => "message_id"
  belongs_to :parent_msg, :class_name => 'Message', :foreign_key => "message_id"
end
