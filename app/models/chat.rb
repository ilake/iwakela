# == Schema Information
# Schema version: 20080916232411
#
# Table name: chats
#
#  id         :integer(11)     not null, primary key
#  user_id    :integer(11)     
#  created_at :datetime        
#  content    :text            
#  group_id   :integer(11)     
#

class Chat < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validates_length_of :content, :minimum => 1, :on => :create

  def self.find_some_chats(params, per_page=10, group=nil)
    if group
      self.paginate :page => params,
                    :per_page => per_page,
                    :order => 'created_at DESC',
                    :conditions => ["created_at > ? AND group_id = ?", Time.now.ago(7.days), group]
    else
      self.paginate :page => params,
                    :per_page => per_page,
                    :order => 'created_at DESC',
                    :conditions => ["created_at > ? AND group_id is NULL", Time.now.ago(7.days)]
    end
  end
end
