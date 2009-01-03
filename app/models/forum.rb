# == Schema Information
# Schema version: 20081227162431
#
# Table name: forums
#
#  id                :integer(11)     not null, primary key
#  subject           :string(255)     
#  content           :text            
#  created_at        :datetime        
#  user_id           :integer(11)     not null
#  comments_count    :integer(11)     default(0)
#  group_id          :integer(11)     
#  last_comment_time :datetime        
#  public            :integer(11)     
#

class Forum < ActiveRecord::Base
  named_scope :no_group, :conditions => {:group_id => nil}
  validates_presence_of :subject, :content

  has_many :comments, :as => :record
  has_one :last_comment, :as => :record,
                         :class_name => 'Comment',
                         :order => 'comments.created_at DESC'
  belongs_to :user
  belongs_to :group

  before_save :set_last_comment_time

  def set_last_comment_time
    self.last_comment_time = Time.now
  end

  def self.find_all_forum(params, group=nil)
    if group
      options = { 
        :per_page => 10,
        :conditions => ["forums.group_id = ?", group]
      }
    else
      options = {
        :per_page => 20,
        :conditions => 'forums.group_id is NULL Or forums.public = 1'
      }
    end

    self.paginate options.merge!(:include => :user, :page => params, :order => "last_comment_time DESC")
  end
end
