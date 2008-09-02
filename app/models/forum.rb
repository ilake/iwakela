# == Schema Information
# Schema version: 20080819065738
#
# Table name: forums
#
#  id             :integer(11)     not null, primary key
#  subject        :string(255)     
#  content        :text            
#  created_at     :datetime        
#  user_id        :integer(11)     not null
#  comments_count :integer(11)     default(0)
#  group_id       :integer(11)     
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

  after_create :default_comment

  def default_comment
    comments.create(:user_id => nil, :content => 'cant be seen')
  end

  def self.find_all_forum(params, group=nil)
    if group
      self.paginate :page => params,
                          :per_page => 10,
                          :include => :comments,
                          :order => 'comments.created_at DESC',
                          :conditions => ["forums.group_id = ?", group]
    else
      self.paginate :page => params,
                          :per_page => 30,
                          :include => :comments,
                          :order => 'comments.created_at DESC',
                          :conditions => 'forums.group_id is NULL'
    end
  end
end
