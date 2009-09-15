# == Schema Information
# Schema version: 20090809070358
#
# Table name: chats
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)      
#  created_at :datetime        
#  content    :text            
#  group_id   :integer(4)      
#

class Chat < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validates_length_of :content, :minimum => 1, :on => :create

  #嘰嘰喳喳先不發到plurk
  #after_create :send_service_msg

  def self.find_some_chats(params, per_page=10, group=nil)
    if group
      self.paginate :page => params,
                    :per_page => per_page,
                    :order => 'created_at DESC',
                    :limit => '100',
                    :include => :user,
                    :conditions => ["chats.group_id = ?", group]
    else
      self.paginate :page => params,
                    :per_page => per_page,
                    :order => 'created_at DESC',
                    :limit => '100',
                    :include => :user,
                    :conditions => "chats.group_id is NULL"
    end
  end

  def send_service_msg
    services = self.user.service_profiles.find(:all)
    services.each do |s|
      case s.service
      when 'plurk'
        begin
          username = s.name
          password = s.password
          @plurk ||= Plurk::Base.new(username,password)
          @plurk.login 
          @plurk.add_plurk(self.content)
        rescue Unavailable
          logger.debug "PLURK_ERROR: #{self.to_yaml}"
        end
      end
    end
  end
end
