# == Schema Information
# Schema version: 20090809070358
#
# Table name: forums
#
#  id                :integer(4)      not null, primary key
#  subject           :string(255)     
#  content           :text            
#  created_at        :datetime        
#  user_id           :integer(4)      not null
#  comments_count    :integer(4)      default(0)
#  group_id          :integer(4)      
#  last_comment_time :datetime        
#  public            :integer(4)      
#  category          :string(255)     
#

#public 0 => private, 團內文章不審核
#       1 => 開放, 某些公開區的需經過審核, 審核過後才會變開放
#       2 => 審核
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
  before_create :set_forum_public_status

  #如果是發在某些需要審核的討論區就把值設成2
  def set_forum_public_status
    #包含在需審核裡的就設2, 不然就設1
    self.public = CONFIRM_CATEGORY.include?(category) ? '2': '1'
  end

  def set_last_comment_time
    self.last_comment_time = Time.now
  end

  def self.find_all_forum(params, group=nil, category=nil, user=nil)
    user_id = user ? user.id : nil
    category = nil if category == 'all'
    if group
      options = { 
        :per_page => 10,
        :conditions => ["forums.group_id = ?", group]
      }
    elsif category
      options = {
        :per_page => 20,
        :conditions => ["(forums.group_id is NULL AND (forums.public = 1 OR forums.user_id = ?)) AND forums.category = ?", user_id, category]
      }
    else
      options = {
        :per_page => 20,
        :conditions => ['forums.group_id is NULL AND (forums.public = 1 OR forums.user_id = ?)', user_id]
      }
    end

    self.paginate options.merge!(:include => :user, :page => params, :order => "last_comment_time DESC")
  end
end
