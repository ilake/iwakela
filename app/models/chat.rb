# == Schema Information
# Schema version: 20081227162431
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
                    :limit => '100',
                    :include => :user,
                    :conditions => ["groups.group_id = ?", group]
    else
      self.paginate :page => params,
                    :per_page => per_page,
                    :order => 'created_at DESC',
                    :limit => '100',
                    :include => :user,
                    :conditions => "groups.group_id is NULL"
    end
  end
end
